#-> perl is v. tolerant about things like parentheses, spacing, etc. Lots of flexibility
#-> philosophically, minimise busywork w/ smart defaults (eg: autoconvert between strings and numbers)
#-> types = scalar, array, hash table, references. That is literally it.

#double quotes = interpret special things
perl -e 'print "Hello world\n"'
perl -e "print \"Hello world\n\"" 
perl -e "print 'Hello world\n'"

#scalar variables begin with a $, automatic interpolation
perl -e '$blah = "Hello"; print "$blah world\n"'

#array interpolation
perl -e '@blah = ("Hello","world"); print "@blah\n"'

#array interpolation controlled by $"
perl -e '$" = "!!!"; @blah = ("Hello","world"); print "@blah\n"'

#index into array with $, concatenate with period.
perl -e '$" = "!!!"; $blah="Whee"; @blah = ("Hello","world"); print "$blah"."whee$blah[1]\n"'

#Convenient loops
#http://perldoc.perl.org/perlrun.html
perl -ne 'print $_' dummy.txt #read line into $_, execute code. Note the newline is part of $_. 
perl -ane '$" = "!!!"; print "raw: $_, split:@F"' dummy.txt
perl -lane '$" = "!!!"; print "raw: $_, split:@F"' dummy.txt
perl -F"\|" -lane '$" = "!!!"; print "raw: $_, split:@F"' dummy.txt 
#I just discovered that the string is interpreted as a regex!
perl -F"\||\s" -lane '$" = "!!!"; print "raw: $_, split:@F"' dummy.txt
#equivalent:
perl -lne '@F = split(/\||\s/, $_); $" = "!!!"; print "raw: $_, split:@F"' dummy.txt

#find and replace with s/.../.../g
perl -lne '$_ =~ s/a/SHIVA DESTROYER OF WORLDS/g; print $_' dummy.txt
#p flag prins contents of $_ at the end.
perl -lpe '$_ =~ s/a/SHIVA DESTROYER OF WORLDS/g' dummy.txt

#pipe
cat dummy.txt | perl -lpe '$_ =~ s/a/SHIVA DESTROYER OF WORLDS/g'

#smart defaults
perl -lpe 's/a/SHIVA DESTROYER OF WORLDS/g' dummy.txt

#line number. Parens needed for if statement!
perl -lpe 'if ($. > 1) {s/a/SHIVA DESTROYER OF WORLDS/g}' dummy.txt

#list comprehension
perl -lane '@arr = map {"hi$_"} @F; print "@arr"' dummy.txt

#ternary operator
perl -lane '@arr = map { ($_ =~ /a/) ? "I_HATE_A" : $_ } @F; print "@arr"' dummy.txt
#multi-line expression with do {..}
#also a period concatenates things
perl -lane '@arr = map { ($_ =~ /a/) ? do {$var="I_HATE"; $var."_A"} : $_ } @F; print "@arr"' dummy.txt

#Foreach (iterates over an array), .. array syntax, automatic array filling, etc
perl -e '@arr = (0,1,2,3,4,5,6,7); print "@arr[0..3,5,6..$#arr]"'
#hacky way to get bash variables in:
HELLO=5
perl -le '$idx='"$HELLO"'; @arr = (0,1,2,3,4,5,6,7); print "@arr[0..3,$idx,6..$#arr]"'
#foreach
perl -lane '@arr = (); foreach $i(0..$#F) {$arr[$i] = $F[$i].":$i"}; print "@arr"' dummy.txt
#scoping
perl -lane '@arr = (); foreach (0..$#F) {$arr[$_] = $F[$_].":$_"}; print "$_\n@arr"' dummy.txt

#hash tables with %. BEGIN for things executed only once
#only print out a line if you have never seen it before
perl -lane 'BEGIN {%seen = ()} {if (!$seen{$_}) {print $_}; $seen{$_}=1}' dummy.txt
#pipe to wc to get number of unique lines; allows you to count unique lines without sorting (uniq requires sorted input)

#If you want to store hash tables or arrays WITHIN other hash tables or arrays, you need to use references! I can explain later.


