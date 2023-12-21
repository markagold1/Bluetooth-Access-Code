% Procedure from Core Spec 5.4 Vol 2 Part B Section 6.3.3.1 pg 473

clear

% Load sample data from Core spec 5.4 Vol 2 Part G section 3 pg 896
% LAP  Preamble Sync Word         Trailer
% 000000 | 5 | 7e7041e3 4000000d | 5 |
% ffffff | a | e758b522 7ffffff2 | a |
% 9e8b33 | 5 | 475c58cc 73345e72 | a |
% 9e8b34 | 5 | 28ed3c34 cb345e72 | a |
% 9e8b36 | 5 | 62337b64 1b345e72 | a |
% 9e8b39 | a | c05747b9 e7345e72 | a |
% 9e8b3d | 5 | 7084eab0 2f345e72 | a |
% 9e8b42 | 5 | 64c86d2b 90b45e72 | a |
% 616cec | 5 | 586a491f 0dcda18d | 5 |
[lap_c,sw_c] = load_test_data();

fails = [];
for kk = 1:numel(lap_c)

    [syncword,syncword_str,syncword_hex] = btsyncgen(lap_c{kk});

    if ~strcmp(syncword_str,sw_c{kk})
        fails = [fails kk];
    end

end % kk

if numel(fails)
    fprintf(1,'Failed test cases:\n');
    disp(fails(:));
else
    fprintf('Success! %d tests ran and passed.\n',kk);
end
