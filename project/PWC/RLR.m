function [Out, zerorun, z_mod] = RLR( InStream, Bs_idx, sign, z, k )

z_mod = z;

n = size(InStream, 2);

zerocnt = 0;
Out = [];
zerorun = [];
out_idx = 1;
for i = 1:n
    %disp(['Value of InStream(i): ', num2str(InStream(i))]);
    
    if InStream(i) == 0
        % Note that we emit code-word only on encountering a 1.
        % For a zero, we just increase the count of zeroes seen so far.
        % So ,for zeros that are at the end of a bit-plane need to be
        % specially accounted for (inserted) while decoding
        zerocnt = zerocnt + 1;
        if zerocnt == (2 ^ k)
            Out(out_idx) = uint8(0);
            out_idx = out_idx + 1;
            zerocnt = 0;
            % Adaptively increasing k as we just emitted a zero
            k = k + 1;
            
        end
    else % Encountered a 1 in Bitstream
          sign_bit = sign(Bs_idx(i));
          z_mod(Bs_idx(i)) = 1;
            
          Out(out_idx) = uint8(1);
          out_idx = out_idx + 1;
          
          % Encode length of zero run as a k-bit number
          %disp(['Value of zerocnt right now: ', num2str(zerocnt), ' and k: ', num2str(k)]);
          run_bitstring = dec2bin(zerocnt);
          len = numel(run_bitstring);
          s = '';
          for j = k:-1:(len + 1)
              s = horzcat(s, dec2bin(0));
          end
          run_bitstring = horzcat(s, run_bitstring); % run_bitstring is now a k-bit number (zero run length)
          zerorun = horzcat(zerorun, run_bitstring);
          %----------
            
          if sign_bit == 0
                Out(out_idx) = uint8(0);
          else
                Out(out_idx) = uint8(1);
          end
          
          out_idx = out_idx + 1;
            
          zerocnt = 0;
          if k > 1
              k = k - 1;
          end
          
    end
    %Out
end

end