function [accesscode_bin,accesscode_str,accesscode_hex] = btaccesscode(LAP)
% Usage: [accesscode_bin,accesscode_str,accesscode_hex] = btaccesscode(LAP)
%
% Calculate Bluetooth Access Code from the 24-bit Lower Address Part (LAP).
%
%   LAP.................Lower Address Part, the following formats are supported
%                       1-by-24 char array of binary digits (left-lsb)
%                           Example: '100111101000101100110011'
%                       1-by-6 char array of hex digits
%                           Examples: '9e8b33', '000b33'
%                       integer in range [0,2^24]
%                           Examples:  0x9e8b33, 10390323
%   accesscode_bin......Sync word, 1-by-72 integer array of binary digits
%   accesscode_str......Sync word, 1-by-72 char array of binary digits
%   accesscode_hex......Sync word, 1-by-18 char array of hex digits
%
%   Example:
%   >> [acbin,acstr,achex] = btsyncgen(0x9e8b33);disp(achex);
%   475c58cc73345e72
%
%   LSB  4                     64                     4   MSB
%   +-------------------------------------------------------+
%   | PREAMBLE |            SYNC WORD            | TRAILER  |
%   +-------------------------------------------------------+
%
%

    % Calculate Sync Word
    [swbin,swstr,swhex] = btsyncgen(LAP);

    % Preamble pattern depends on the first bit of the sync word
    if swbin(1)
        preamble_bin = [1 0 1 0];
        preamble_str = '1010';
        preamble_hex = 'a';
    else
        preamble_bin = [0 1 0 1];
        preamble_str = '0101';
        preamble_hex = '5';
    end

    % Trailer pattern depends on the last bit of the sync word
    if swbin(end)
        trailer_bin = [0 1 0 1];
        trailer_str = '0101';
        trailer_hex = '5';
    else
        trailer_bin = [1 0 1 0];
        trailer_str = '1010';
        trailer_hex = 'a';
    end

    % Assemble the Access Code
    accesscode_bin = [preamble_bin swbin trailer_bin];
    accesscode_str = [preamble_str swstr trailer_str];
    accesscode_hex = [preamble_hex swhex trailer_hex];

end % function
