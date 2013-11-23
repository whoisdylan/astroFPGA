function [denominator] = denominator_comparison(t,f)
tbar = fix(mean(t(:)));
fbar = fix(mean(f(:)));

%tNew = t-tbar;
%fNew = f-fbar;
tNew = t;
fNew = f;

[isZeroRow, isZeroCol] = find(tNew == 0);
if (~isempty(isZeroRow))
	for i = 1:size(isZeroRow,1)
		tNew(isZeroRow(i), isZeroCol(i)) = 1;
	end
end

[isZeroRow, isZeroCol] = find(fNew == 0);
if (~isempty(isZeroRow))
	for i = 1:size(isZeroRow,1)
		fNew(isZeroRow(i), isZeroCol(i)) = 1;
	end
end

denominator = sqrt(sum(sum(tNew.*tNew))*sum(sum(fNew.*fNew)));

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


tlog2 = fi(tlog2,0,25,12)
flog2 = fi(flog2,0,25,12)
tlog2 = bitshift(tlog2, 1);
flog2 = bitshift(flog2, 1);

rettlog2 = fi(tlog2,0,28,12);
retflog2 = fi(flog2,0,28,12);
tlog2 = double(tlog2);
flog2 = double(flog2);

disp('t and f double summed');
t=2.^tlog2;
f=2.^flog2;

t = sum(sum(t));
f = sum(sum(f));

t = log2(t);
f = log2(f);

t = fi(t, 0, 64, 32);
f = fi(f, 0, 64, 32);

total = t+f;
total = bitshift(total,-1);
total = double(total);
total = 2^total;

denominator
denominator = total;
end
