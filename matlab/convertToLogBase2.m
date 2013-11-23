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
