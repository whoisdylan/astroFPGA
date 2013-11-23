function [lg10Num] = convertToLogBase10(fprime)

	%separate the number into high and low bits.
	fractPortion = abs(fprime) - fix(abs(fprime));
	intPortion = abs(fix(fprime));
	lg10Num = bitshift(1, double(intPortion))+fractPortion*bitshift(1,double(intPortion));
	

end
