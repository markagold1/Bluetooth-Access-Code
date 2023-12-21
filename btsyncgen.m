function [syncword_bin,syncword_str,syncword_hex] = btsyncgen(LAP)
% Usage: [syncword_bin,syncword_str,syncword_hex] = btsyncgen(LAP)
%
% Generate the sync word field of the Bluetooth Access Code from the
% 24-bit Lower Address Part (LAP).
%
%   LAP.................Lower Address Part, the following formats are supported
%                       1-by-24 char array of binary digits (left-lsb)
%                           Example: '100111101000101100110011'
%                       1-by-6 char array of hex digits
%                           Examples: '9e8b33', '000b33'
%                       integer in range [0,2^24]
%                           Examples:  0x9e8b33, 10390323
%   syncword_bin........Sync word, 1-by-64 integer array of binary digits
%   syncword_str........Sync word, 1-by-64 char array of binary digits
%   syncword_hex........Sync word, 1-by-16 char array of hex digits
%
%   Examples:
%   >> [swbin,swstr,swhex] = btsyncgen('100111101000101100110011');disp(swhex);
%   475c58cc73345e72
%
%   >> [swbin,swstr,swhex] = btsyncgen('9e8b33'); disp(swhex);
%   475c58cc73345e72
%
%   >> [swbin,swstr,swhex] = btsyncgen(0x9e8b33); disp(swhex);
%   475c58cc73345e72
%

    % Validate input format
    LAPIN = LAP;
    if isnumeric(LAP)
        LAP = de2bi(double(LAP),24,'left-msb');
        LAP = bnvxbns(LAP);
    elseif ischar(LAP) && numel(LAP) == 6
        LAP = h2b(LAP);
    end

    % Procedure from Core Spec 5.4 Part B Section 6.3.3.1 pg 473

    % fetch data for next test case
    lap = bnvxbns(LAP);
    lap = fliplr(lap);

     % Append barker code
     if lap(end) == 0
         a = [lap 0 0 1 1 0 1];
     else
         a = [lap 1 1 0 0 1 0];
     end

    % Generate 63-bit PN sequence
    %       0   2 3   5 6
    %png = [1 0 1 1 0 1 1]; % 1 + D + D^3 + D^4 + D^6
    %pnseq = '3F2A33DD69B121C1';
    [seq,~] = lfsr_ssrg(63,[6 5 3 2 0],1);
    % Left-most bit is p0 and right-most bit p63
    p = [0 seq(end:-1:1)]; % prepend 0 for 64 bits total
    ps = bnvxbns(p);        %debug
    phexstr = bns2hex(ps);  %debug

    % Scramble LAP and Barker code with pn bits 34..63
    x_tilde = bitxor(a(1:30), p(35:64));

    % Expurgated code (octal, left-msb)
    % g(D) = 260534236651
    gdbns = dec2base(base2dec('260534236651',8),2);
    gdbnv = bnvxbns(gdbns);  %debug
    gdocs = bns2oct(gdbns);  %debug

    % Parity bits
    [r] = lfsr_msrg_crc(fliplr(x_tilde), gdbns);
    rs = bnvxbns(double(r));  %debug

    % Codeword
    cw = [r x_tilde];

    % XOR codeword with PN sequence
    syncword_bin = bitxor(cw, p);
    syncword_str = bnvxbns(syncword_bin);
    syncword_hex = bns2hex(syncword_str);

end % function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bout = bnvxbns(bin)
% Usage: bout = bnvxbns(bin)
%
%  Convert binary vector to binary string
%  or binary string to binary vector.
%

    if isnumeric(bin)
        bout = strrep(num2str(bin),' ','');
    else
        bout = str2num(sprintf('%c ',bin));
    end

end % function

function hexstr = bns2hex(binstr)
% Usage: hexstr = bns2hex(binstr)
%
%  Convert binary string to hex string.
%

    % prepend zeros to nearest multiple of 4
    bs = [repmat('0',1,rem(4-rem(numel(binstr),4),4)) binstr];

    bsr = reshape(bs(:),4,numel(bs)/4).';
    dec = base2dec(bsr,2);
    hexstr = dec2base(dec,16);
    hexstr = lower(hexstr(:).');

end % function

function octstr = bns2oct(binstr)
% Usage: octstr = bns2oct(binstr)
%
%  Convert binary string to oct string.
%

    % prepend zeros to nearest multiple of 3
    bs = [repmat('0',1,rem(3-rem(numel(binstr),3),3)) binstr];

    bsr = reshape(bs(:),3,numel(bs)/3).';
    dec = base2dec(bsr,2);
    octstr = dec2base(dec,8);
    octstr = lower(octstr(:).');

end % function

function b = h2b(h)
    b = '';
    for kk = 1:numel(h)
        b = [b lut(hex2dec(h(kk)))];
    end
end % function

function b = lut(n)
    s = [ '0000'; '0001'; '0010'; '0011'; 
          '0100'; '0101'; '0110'; '0111';
          '1000'; '1001'; '1010'; '1011';
          '1100'; '1101'; '1110'; '1111' ];
    b = s(n+1,:);
end % function

function d = bi2de(b, p, f)
% Usage: b = bi2de(b, p, f)
%
% Convert binary vectors to decimal numbers.
%
% b..........binary vector to convert
% p..........optional base of vector to convert from (default=2)
% f..........flag defining the target orientation
%            one of : 'left-msb', 'right-msb'
%            default is 'right'msb'
%

    switch (nargin)
      case 1
        p = 2;
        f = "right-msb";
      case 2
        if (ischar (p))
          f = p;
          p = 2;
        else
          f = "right-msb";
        end
      case 3
        if (ischar (p))
          tmp = f;
          f = p;
          p = tmp;
        end
      otherwise
        help bi2de
        return
    end

    if (~ (all (b(:) == fix (b(:))) && all (b(:) >= 0) && all (b(:) < p)))
      error ("bi2de: all elements of B must be integers in the range [0,P-1]");
    end

    if (strcmp (f, "left-msb"))
      b = b(:,size (b, 2):-1:1);
    elseif (~strcmp (f, "right-msb"))
      error ("bi2de: invalid option '%s'", f);
    end

    if (length (b) == 0)
      d = [];
    else
      d = b * (p .^ [0:(columns (b) - 1)]');
    end
end % function

function b = de2bi(d, n, p, f)
% Usage: b = de2bi(d, n, p, f)
%
% Convert decimal numbers to binary vectors.
%
% d..........decimal number to convert
% n..........number of binary digits to create
% p..........optional base to convert to (default=2)
% f..........flag defining the target orientation
%            one of : 'left-msb', 'right-msb'
%            default is 'right'msb'
%

    if (nargin == 1)
      p = 2;
      n = floor ( log (max (max (d), 1)) ./ log (p) ) + 1;
      f = "right-msb";
    elseif (nargin == 2)
      p = 2;
      f = "right-msb";
    elseif (nargin == 3)
      if (ischar (p))
        f = p;
        p = 2;
      else
        f = "right-msb";
      end
    elseif (nargin == 4)
      if (ischar (p))
        tmp = f;
        f = p;
        p = tmp;
      end
    else
      help de2bi
      return
    end

    d = d(:);
    if (~ (all (d == fix (d)) && all (d >= 0)))
      error ("de2bi: all elements of D must be non-negative integers");
    end

    if (isempty (n))
      n = floor ( log (max (max (d), 1)) ./ log (p) ) + 1;
    end

    power = ones (length (d), 1) * (p .^ [0 : n-1] );
    d = d * ones (1, n);
    b = floor (rem (d, p*power) ./ power);

    if (strcmp (f, "left-msb"))
      b = b(:,columns(b):-1:1);
    elseif (~strcmp (f, "right-msb"))
      error ("de2bi: invalid option '%s'", f);
    end
end % function

function y = columns(x)
  y = size(x,2);
end % function

function [seq,fill] = lfsr_ssrg(num,poly,ifill)
% Usage: [seq,fill] = lfsr_ssrg(num,poly,ifill)
%
% poly...numeric vector containing the exponents of z 
%        for the nonzero terms of the polynomial in 
%        descending order of powers
% ifill..scalar, initial shift register state
%
%   +--------(+)<-----(+)-----(+)<-------+
%   | r       ^ r-1    ^ r-2   ^         |
%   |z        |z       |z      |z        |1
%   +-->|r-1|-+->|r-2|-+- ... -+->| 0 |--+------> seq
%
% Example:
%
%  [seq,fill]=lfsr_ssrg(32,[5,3,0],1);
%
% All binary vectors use 'left-msb' orientation
%

    seq = NaN(1,num);
    degree = poly(1);
    taps(1+degree-poly) = 1;
    sr = de2bi(ifill,degree,'left-msb');
    for nn = 1:num
        seq(nn) = sr(end);
        parity = mod(sum(and(taps(2:end),sr)),2);
        sr = [parity sr(1:end-1)];
    end;

    % final fill
    fill = bi2de(sr,'left-msb');

end % function

function [sr] = lfsr_msrg_crc(data,poly)
% Usage: [sr] = lfsr_msrg_crc(data,poly)
%
% data...numeric vector of 1s and 0s representing the dividend polynomial
% poly...numeric vector representing the divisor polynomaial
%        poly contains the exponents of z for the nonzero coefficients
%        of the divisor polynomial in descending powers
%        alternatively poly can be a character array of 1s and 0s
%        explicitly defining the non-zero coefficients
% sr.....numeric vector of 1s and 0s containng the final shift register state
%        in crc applications the final shift register state contains
%        the crc result
%
% data --->(+)-----------+-----------+----------+----------+
%           ^   r        |  r-1      |  r-2     |  1       |  0
%           |  z         v z         v z        v z        | z
%           +<---|r-1|<-(+)<-|r-2|<-(+)<-...<--(+)<-| 0 |<-+
%
% Example: The following two calls are equivalent
%
%  [sr]=lfsr_msrg_crc([1 0 1 1 0 1 1 0 1 1 0 1],[5,3,0]);
%  [sr]=lfsr_msrg_crc([1 0 1 1 0 1 1 0 1 1 0 1],'101001');
%
% All binary vectors use 'left-msb' orientation
%

    % initial shift register (sr) fill
    ifill = 0;

    if ischar(poly)
        % character array of 1s and 0s
        if poly(1) ~= '1' || poly(end) ~= '1'
            error('First and last coefficients of tap polynomial must be 1.\n');
        end
        mm = 0;
        polys = poly;
        poly = [];
        for kk = 1:numel(polys)
            if polys(kk) == '1'
                mm = mm + 1;
                poly(mm) = kk - 1;
            end
        end
        degree = numel(polys)-1;
        taps(1+degree-poly) = 1;
        taps = taps(end:-1:1);
    else
        % numeric array of 1s and 0s
        degree = poly(1);
        taps(1+degree-poly) = 1;
    end

    sr = de2bi(ifill,degree,'left-msb');
    for nn = 1:numel(data)
        fb = xor(sr(1),data(nn));
        if fb
            sr = [xor(sr(2:end),taps(2:end-1)) fb];
        else
            sr = [sr(2:end) fb];
        end
    end
    sr = fliplr(sr);

end % function

% <<END>>
