function [lap_c, sw_c, pream_c, trail_c, accesscode_c] = load_test_data()
% Usage: [lap_c, sw_c, pream_c, trail_c, accesscode_c] = load_test_data()
%

    test_array = fetch_test_data();

    lap_c = {};
    sw_c = {};
    pream_c = {};
    trail_c = {};
    accesscode_c = {};
    for kk = 1:size(test_array,1)
        row = test_array(kk,:);
        laphex = row(1:6);
        preamblehex = row(10);
        swhex = [row(14:21) row(23:30)];
        trailerhex = row(34);
        lapbin = h2b(laphex);
        preamblebin = h2b(preamblehex);
        swbin = h2b(swhex);
        trailerbin = h2b(trailerhex);
        lap_c{end+1} = lapbin;
        pream_c{end+1} = preamblebin;
        sw_c{end+1} = swbin;
        trail_c{end+1} = trailerbin;
        accesscode_c{end+1} = [preamblebin swbin trailerbin];
    end
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

function test_array = fetch_test_data()

% Access code sample data from Bluetooth Core spec 5.4.
% Part G section 3 pg 896

    test_array = [
%   LAP  Preamble Sync Word          Trailer
%   --------+---+-------------------+--------
    '000000 | 5 | 7e7041e3 4000000d | 5 |'
    'ffffff | a | e758b522 7ffffff2 | a |'
    '9e8b33 | 5 | 475c58cc 73345e72 | a |'
    '9e8b34 | 5 | 28ed3c34 cb345e72 | a |'
    '9e8b36 | 5 | 62337b64 1b345e72 | a |'
    '9e8b39 | a | c05747b9 e7345e72 | a |'
    '9e8b3d | 5 | 7084eab0 2f345e72 | a |'
    '9e8b42 | 5 | 64c86d2b 90b45e72 | a |'
    '9e8b48 | a | e3c3725e 04b45e72 | a |'
    '9e8b4f | a | 8c7216a6 bcb45e72 | a |'
    '9e8b57 | a | b2f16c30 fab45e72 | a |'
    '9e8b60 | 5 | 57bd3b22 c1b45e72 | a |'
    '9e8b6a | a | d0b62457 55b45e72 | a |'
    '9e8b75 | a | 81843a39 abb45e72 | a |'
    '9e8b81 | 5 | 0ca96681 e0745e72 | a |'
    '9e8b8e | a | aecd5a5c 1c745e72 | a |'
    '9e8b9c | 5 | 17453fbf ce745e72 | a |'
    '9e8bab | a | f20968ad f5745e72 | a |'
    '9e8bbb | 5 | 015f4a1e f7745e72 | a |'
    '9e8bcc | a | d8c695a0 0cf45e72 | a |'
    '9e8bde | 5 | 614ef043 def45e72 | a |'
    '9e8bf1 | a | ba81ddc7 a3f45e72 | a |'
    '9e8c05 | 5 | 64a7dc4f 680c5e72 | a |'
    '9e8c1a | 5 | 3595c221 960c5e72 | a |'
    '9e8c30 | a | cb35cc0d 830c5e72 | a |'
    '9e8c47 | 5 | 12ac13b3 788c5e72 | a |'
    '9e8c5f | 5 | 2c2f6925 3e8c5e72 | a |'
    '9e8c78 | 5 | 3a351c84 078c5e72 | a |'
    '9e8c92 | 5 | 7396d0f3 124c5e72 | a |'
    '9e8cad | 5 | 5b0fdfc4 6d4c5e72 | a |'
    '9e8cc9 | a | aea2eb38 e4cc5e72 | a |'
    '9e8ce6 | 5 | 756dc6bc 99cc5e72 | a |'
    '9e8d04 | 5 | 214cf934 882c5e72 | a |'
    '9e8d23 | 5 | 37568c95 b12c5e72 | a |'
    '9e8d43 | 5 | 72281560 f0ac5e72 | a |'
    '9e8d64 | 5 | 643260c1 c9ac5e72 | a |'
    '9e8d86 | a | e044f493 986c5e72 | a |'
    '9e8da9 | 5 | 3b8bd917 e56c5e72 | a |'
    '9e8dcd | a | ce26edeb 6cec5e72 | a |'
    '9e8df2 | a | e6bfe2dc 13ec5e72 | a |'
    '9e8e18 | a | 82dcde3d c61c5e72 | a |'
    '9e8e3f | a | 94c6ab9c ff1c5e72 | a |'
    '9e8e67 | a | 969059a6 799c5e72 | a |'
    '9e8e90 | a | c4dfccef 425c5e72 | a |'
    '9e8eba | 5 | 3a7fc2c3 575c5e72 | a |'
    '9e8ee5 | 5 | 57985401 69dc5e72 | a |'
    '9e8f11 | 5 | 0ae2a363 623c5e72 | a |'
    '9e8f3e | a | d12d8ee7 1f3c5e72 | a |'
    '9e8f6c | 5 | 547063a8 0dbc5e72 | a |'
    '9e8f9b | 5 | 063ff6e1 367c5e72 | a |'
    '9e8fcb | a | c9bc5cfe f4fc5e72 | a |'
    '9e8ffc | 5 | 2cf00bec cffc5e72 | a |'
    '9e902e | a | 8ec5052f 5d025e72 | a |'
    '9e9061 | 5 | 1074b15e 61825e72 | a |'
    '9e9095 | a | 9d59ede6 2a425e72 | a |'
    '9e90ca | a | f0be7b24 14c25e72 | a |'
    '9e9100 | 5 | 10e10dd0 c0225e72 | a |'
    '9e9137 | a | f5ad5ac2 fb225e72 | a |'
    '9e916f | a | f7fba8f8 7da25e72 | a |'
    '9e91a8 | 5 | 2f490e5b c5625e72 | a |'
    '9e91e2 | a | 94979982 91e25e72 | a |'
    '9e921d | 5 | 26cda478 2e125e72 | a |'
    '9e9259 | a | aacb81dd 26925e72 | a |'
    '9e9296 | a | bfac7f5b da525e72 | a |'
    '9e92d4 | a | c9a7b0a7 cad25e72 | a |'
    '9e9313 | a | c142bdde 32325e72 | a |'
    '616cec | 5 | 586a491f 0dcda18d | 5 |'
    '616ceb | 5 | 37db2de7 b5cda18d | 5 |'
    '616ce9 | 5 | 7d056ab7 65cda18d | 5 |'
    '616ce6 | a | df61566a 99cda18d | 5 |'
    '616ce2 | 5 | 6fb2fb63 51cda18d | 5 |'
    '616cdd | 5 | 472bf454 2ecda18d | 5 |'
    '616cd7 | a | c020eb21 bacda18d | 5 |'
    '616cd0 | a | af918fd9 02cda18d | 5 |'
    '616cc8 | a | 9112f54f 44cda18d | 5 |'
    '616cbf | 5 | 488b2af1 bf4da18d | 5 |'
    '616cb5 | a | cf803584 2b4da18d | 5 |'
    '616caa | a | 9eb22bea d54da18d | 5 |'
    '616c9e | a | a49cb509 9e4da18d | 5 |'
    '616c91 | 5 | 06f889d4 624da18d | 5 |'
    '616c83 | a | bf70ec37 b04da18d | 5 |'
    '616c74 | a | ed3f797e 8b8da18d | 5 |'
    '616c64 | 5 | 1e695bcd 898da18d | 5 |'
    '616c53 | a | fb250cdf b28da18d | 5 |'
    '616c41 | 5 | 42ad693c 608da18d | 5 |'
    '616c2e | a | a5b7cc14 dd0da18d | 5 |'
    '616c1a | a | 9f9952f7 960da18d | 5 |'
    '616c05 | a | ceab4c99 680da18d | 5 |'
    '616bef | a | d403ddde fdf5a18d | 5 |'
    '616bd8 | 5 | 314f8acc c6f5a18d | 5 |'
    '616bc0 | 5 | 0fccf05a 80f5a18d | 5 |'
    '616ba7 | 5 | 25030d57 7975a18d | 5 |'
    '616b8d | a | dba3037b 6c75a18d | 5 |'
    '616b72 | 5 | 4439ce17 13b5a18d | 5 |'
    '616b56 | a | 8d417247 5ab5a18d | 5 |'
    '616b39 | 5 | 6a5bd76f e735a18d | 5 |'
    '616b1b | 5 | 592e8166 b635a18d | 5 |'
    '616afc | 5 | 28609d46 cfd5a18d | 5 |'
    '616adc | 5 | 51cb8c1f 4ed5a18d | 5 |'
    '616abb | 5 | 7b047112 b755a18d | 5 |'
    '616a99 | 5 | 4871271b e655a18d | 5 |'
    '616a76 | 5 | 24bdc8c4 9b95a18d | 5 |'
    '616a52 | a | edc57494 d295a18d | 5 |'
    '616a2d | a | f989f30f 6d15a18d | 5 |'
    '616a07 | 5 | 0729fd23 7815a18d | 5 |'
    '6169e0 | a | 8bf0ba4f 81e5a18d | 5 |'
    '6169b8 | a | 89a64875 0765a18d | 5 |'
    '61698f | 5 | 6cea1f67 3c65a18d | 5 |'
    '616965 | 5 | 2549d310 29a5a18d | 5 |'
    '61693a | 5 | 48ae45d2 1725a18d | 5 |'
    '61690e | 5 | 7280db31 5c25a18d | 5 |'
    '6168e1 | a | ce1b9f34 61c5a18d | 5 |'
    '6168b3 | 5 | 4b46727b 7345a18d | 5 |'
    '616884 | a | ae0a2569 4845a18d | 5 |'
    '616854 | a | ea5fc581 4a85a18d | 5 |'
    '616823 | 5 | 33c61a3f b105a18d | 5 |'
    '6167f1 | a | c49fb8c5 63f9a18d | 5 |'
    '6167be | 5 | 5a2e0cb4 5f79a18d | 5 |'
    '61678a | 5 | 60009257 1479a18d | 5 |'
    '616755 | a | 86314e62 eab9a18d | 5 |'
    '61671f | 5 | 3defd9bb be39a18d | 5 |'
    '6166e8 | a | bff7e728 c5d9a18d | 5 |'
    '6166b0 | a | bda11512 4359a18d | 5 |'
    '616677 | 5 | 6513b3b1 fb99a18d | 5 |'
    '61663d | a | decd2468 af19a18d | 5 |'
    '616602 | a | f6542b5f d019a18d | 5 |'
    '6165c6 | a | dc44b49b d8e9a18d | 5 |'
    '616589 | 5 | 42f500ea e469a18d | 5 |'
    '61654b | a | bf2885e1 34a9a18d | 5 |'
    '61650c | a | ec4c69b5 4c29a18d | 5 |' ];

end % function
