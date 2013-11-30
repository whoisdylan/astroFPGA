function [] = fpga_ncc(f,t)
	numerator = computeNumerator(f,t)
	denominator = computeDenominator(f,t)

	if (numerator < 0)
		numSign = -1;
	else
		numSign = 1;
	end

	if (denominator < 0)
		denSign = -1;
	else
		denSign = 1;
	end

	numerator = convertToLogBase2(abs(numerator));
	denominator = convertToLogBase2(abs(denominator));

	ncc_var = fi(numerator,1) - fi(denominator,1);

	fractPortion = abs(ncc_var) - fix(abs(ncc_var));
	intPortion = abs(fix(ncc_var));

	if (ncc_var < 0)
		nccSign = -1;
	else
		nccSign = 1;
	end
	fractPortion
	intPortion
	if (intPortion ~= 0)
		ncc_var = numSign*denSign*...
				(bitshift(1, double(nccSign*intPortion)) + ...
				bitshift(fractPortion, nccSign*(double(intPortion+1))));
	else
		ncc_var = numSign*denSign*bitshift(abs(ncc_var), nccSign*double(intPortion+2));
	end

	disp('FPGA version produces')
	ncc_var

	disp('real version produces')
	ncc(f,t)

end

function [numerator] = computeNumerator(f,t)
f = fix(f-mean(f(:)));
t = fix(t-mean(t(:)));

total = 0;

for i = 1:size(t,1)
	for j = 1:size(t,2)

		%check sign
		if (f(i,j) < 0)
			signF(i,j) = -1;
		else
			signF(i,j) = 1;
		end

		if (t(i,j) < 0)
			signT(i,j) = -1;
		else
			signT(i,j) = 1;
		end

		summedLogs(i,j) = convertToLogBase10(convertToLogBase2(abs(f(i,j)))+convertToLogBase2(abs(t(i,j))));

		total(i,j) = fi(summedLogs(i,j),1)*(signT(i,j)*signF(i,j));
	end
end

numerator = sum(sum(total));
end

function [den] = computeDenominator(f,t)
f = fix(f-mean(f(:)));
t = fix(t-mean(t(:)));

for i = 1:size(t,1)
	for j = 1:size(t,2)

		%check sign
		if (f(i,j) < 0)
			signF(i,j) = -1;
		else
			signF(i,j) = 1;
		end

		if (t(i,j) < 0)
			signT(i,j) = -1;
		else
			signT(i,j) = 1;
		end
		
		den1(i,j) = convertToLogBase10(convertToLogBase2(abs(f(i,j))) +convertToLogBase2(abs(f(i,j))));
		den2(i,j) = convertToLogBase10(convertToLogBase2(abs(t(i,j))) +convertToLogBase2(abs(t(i,j))));
	end
end

	den1 = sum(sum(den1));
	den2 = sum(sum(den2));

	den1 = convertToLogBase2(den1);
	den2 = convertToLogBase2(den2);

	den = den1+den2;

	den = bitshift(fi(den,1), -1);

	den = convertToLogBase10(den);
	den
end

function [lg2Num] = convertToLogBase2(fprime)

	%convert each pixel to uint8
	fprime = double(fprime);
	firstOnes = findFirstOne(fix(fprime));
	firstZeros = findFirstZero(fix(fprime));
	intPortion = firstOnes;
	mask = bitshift(1, intPortion);
	fractPortion = bitxor(int64(fprime), int64(mask));

	%create fixed point number from the index you got in firstOnes
	%and the fractional components you got in shifted
	intFXP = fi(intPortion, 0, 64, 54);
	fractFXP = fi(fractPortion, 0, 64, 54);
	fractFXP = fractFXP/(bitshift(1, firstOnes));
	lg2Num = intFXP + fractFXP;

	%lg2Num = fi(firstOnes, 0, 3);
	%fraction = bitshift(fi(double(shifted)), -7);
	%lg2Num = lg2Num+fraction;
	
	
end


function [lg10Num] = convertToLogBase10(fprime)

	%separate the number into high and low bits.
	fractPortion = abs(fprime) - fix(abs(fprime));
	intPortion = abs(fix(fprime));
	lg10Num = bitshift(1, double(intPortion))+fractPortion*bitshift(1,double(intPortion));
	
end

function ans = findFirstOne(x)
	ans = findFirstZero(x);
	ans = 31-ans;
end

function ans = findFirstZero(x)
	n = 0;

	if (~isa(x,'double'))
		warning('Input must have class type double.  Casting to double...')
		x = double(x);
	end
	if ( x == 0) n = 31;
	else 
		if (x <= hex2dec('0000ffff')) 
		n = n + 16;
		x = bitshift(x,16);
		end
		if (x <= hex2dec('00ffffff'))
		n = n + 8;
		x = bitshift(x,8);
		end
		if (x <= hex2dec('0fffffff'))
		n = n + 4;
		x = bitshift(x,4);
		end
		if (x <= hex2dec('3fffffff'))
			n = n + 2;
			x = bitshift(x,2);
		end
		if (x <= hex2dec('7fffffff'))
			n = n + 1;
		end
	end

	ans = n;
end
