R1 = 195
G1 = 106
B1 = 22

R2 = 145
G2 = 130
B2 = 51

R3 = 128
G3 = 135
B3 = 62

NewColorR = sqrt((R1^2+R2^2 + R3^2)/3)
NewColorG = sqrt((G1^2+G2^2 + G3^2)/3)
NewColorB = sqrt((B1^2+B2^2 + B3^2)/3)

horzcat(NewColorR,NewColorG,NewColorB)

% keep in mind how each approach does the test, if both significant what does that say about underlying fx
%mod mdeiation denotes relationship betw pred and vars, directionality, ordering 
