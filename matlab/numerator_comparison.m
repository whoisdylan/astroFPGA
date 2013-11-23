%WORKS AS LONG AS THERE IS NO ZERO IN THE VALUE YOU ARE NCC'ing
function [numerator] = numerator_comparison(t,f)
[isZeroRow, isZeroCol] = find(t == 0);
if (~isempty(isZeroRow))
	for i = 1:size(isZeroRow,1)
		t(isZeroRow(i), isZeroCol(i)) = 1;
	end
end

[isZeroRow, isZeroCol] = find(f == 0);
if (~isempty(isZeroRow))
	for i = 1:size(isZeroRow,1)
		f(isZeroRow, isZeroCol) = 1;
	end
end


tbar = fix(mean(t(:)));
fbar = fix(mean(f(:)));

%tNew = t-tbar;
%fNew = f-fbar;
tNew = t;
fNew = f;

numerator = tNew.*fNew;

%get the entries less than 0	
[tNegRows, tNegCols] = find(tNew < 0);
[fNegRows, fNegCols] = find(fNew < 0);

tabs = abs(tNew);
fabs = abs(fNew);
tlog2 = log2(tabs);
flog2 = log2(fabs);

%find the rows/columns where both entries are negative
[~,i,j] = intersect([tNegRows, tNegCols], [fNegRows, fNegCols], 'rows');
tNeg = [tNegRows, tNegCols];
fNeg = [fNegRows, fNegCols];
tNeg(i,:) = [];
fNeg(j,:) = [];

total = tlog2+flog2;
total = 2.^total;

if (~isempty(tNeg)) 
	for i = 1:size(tNeg,1)
		total(tNeg(i,1),tNeg(i,2)) = -total(tNeg(i,1),tNeg(i,2));
	end
end
if (~isempty(fNeg)) 
	for i = 1:size(fNeg,1)
		total(fNeg(i,1),fNeg(i,2)) = - total(fNeg(i,1), fNeg(i,2));
	end
end

total = sum(sum(total));

numerator
numerator = total;
end
