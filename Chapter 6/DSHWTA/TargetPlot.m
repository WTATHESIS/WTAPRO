function [] = TargetPlot(magnifyMultiple,targetX,targetY,targetZ,targetPhi,targetTheta,targetGamma,targetColor)
%TARGETPLOT 此处显示有关此函数的摘要
%   此处显示详细说明
TR=[1 50 41;1 51 50;2 51 1;3 51 2;3 53 51;3 43 53;3 4 43;4 3 52;5 4 52;5 47 4;5 49 47;6 49 5;6 54 49;7 54 6;8 54 7;9 54 8;9 16 54;9 10 16;10 9 28;11 10 28;11 14 10;11 13 14;12 13 11;13 12 24;13 24 14;14 24 20;15 14 20;15 10 14;16 10 15;15 48 16;17 48 15;17 37 48;17 36 37;18 36 17;18 8 36;19 8 18;9 8 19;9 19 28;19 55 28;19 35 55;19 18 35;18 20 35;18 17 20;17 15 20;20 24 35;21 35 24;22 35 21;22 34 35;22 28 34;22 29 28;22 23 29;23 22 21;23 21 56;21 33 56;21 24 33;24 25 33;12 25 24;25 12 11;25 11 26;26 32 25;26 27 32;27 26 30;26 29 30;11 29 26;28 29 11;29 23 30;30 23 56;27 30 56;31 27 56;32 27 31;33 32 31;25 32 33;33 31 56;34 28 55;35 34 55;36 8 7;36 7 38;37 36 38;38 46 37;38 39 46;39 38 7;40 39 7;39 40 1;1 45 39;1 41 45;41 42 45;42 41 43;43 4 42;42 4 44;42 44 45;44 47 45;4 47 44;45 47 46;45 46 39;46 47 37;37 47 48;47 49 48;48 49 16;49 54 16;41 50 43;50 53 43;51 53 50;1 40 2;2 40 3;3 40 52;52 40 7;6 52 7;6 5 52;57 60 59;57 58 60;58 57 61;57 62 61;57 59 62;59 58 62;60 58 59;61 62 58;63 64 66;64 63 68;64 68 67;65 64 67;66 64 65;63 66 65;63 65 67;67 68 63;69 71 73;70 71 69;71 70 74;70 73 74;70 69 73;72 74 73;72 71 74;71 72 73;75 76 79;76 75 77;77 75 80;75 79 80;78 80 79;78 76 80;76 78 79;76 77 80;81 82 85;82 81 83;83 81 86;81 85 86;84 86 85;84 82 86;82 84 85;82 83 86];
X=[0.4 0.025 -0.0433012701892219;0.4 0.05 0;0.4 0.025 0.0433012701892219;0.4 -0.025 0.0433012701892219;0.3 -0.035 0.0606217782649107;0.2 0.035 0.0606217782649107;0.2 0.07 0;0 0.065 0;-0.1 0.03 0.0519615242270663;-0.1 -0.03 0.0519615242270663;-0.2 -0.025 0.0433012701892219;-0.3 -0.04 0;-0.2 -0.05 0;-0.1 -0.06 0;0 -0.065 0;0 -0.0325 0.0562916512459885;0 -0.0325 -0.0562916512459885;-0.1 0.03 -0.0519615242270663;-0.1 0.06 0;-0.1 -0.03 -0.0519615242270663;-0.4 0.015 -0.0259807621135332;-0.4 0.03 0;-0.5 0.02 0;-0.2 -0.025 -0.0433012701892219;-0.4 -0.03 0;-0.4 -0.015 0.0259807621135332;-0.5 -0.01 0.0173205080756888;-0.2 0.025 0.0433012701892219;-0.4 0.015 0.0259807621135332;-0.5 0.01 0.0173205080756888;-0.5 -0.01 -0.0173205080756888;-0.5 -0.02 0;-0.4 -0.015 -0.0259807621135332;-0.3 0.04 0;-0.2 0.025 -0.0433012701892219;0 0.0325 -0.0562916512459885;0.2 -0.035 -0.0606217782649107;0.2 0.035 -0.0606217782649107;0.3 0.035 -0.0606217782649107;0.3 0.07 0;0.5 -0.01 -0.0173205080756888;0.5 -0.02 0;0.5 -0.01 0.0173205080756888;0.4 -0.05 0;0.4 -0.025 -0.0433012701892219;0.3 -0.035 -0.0606217782649107;0.3 -0.07 0;0.2 -0.07 0;0.2 -0.035 0.0606217782649107;0.5 0.01 -0.0173205080756888;0.5 0.02 0;0.3 0.035 0.0606217782649107;0.5 0.01 0.0173205080756888;0 0.0325 0.0562916512459885;-0.2 0.05 0;-0.5 0.01 -0.0173205080756888;0.2 0.0657784834550136 0.0239414100327968;0 0.0562916512459885 -0.0325;0.05 0.5 0;0.2 0.07 -0;0 0.061080020351084 0.0222313093161685;-0.05 0.5 0;0 -0.0562916512459885 -0.0325;0.2 -0.0657784834550136 0.0239414100327968;0.05 -0.5 0;0.2 -0.07 -0;-0.05 -0.5 0;0 -0.061080020351084 0.0222313093161685;-0.45 0.2 0;-0.4 0.0259807621135332 0.015;-0.4 0.0259807621135332 -0.015;-0.5 0.0173205080756888 -0.01;-0.5 0.2 0;-0.5 0.0173205080756888 0.01;-0.4 -0.0259807621135332 0.015;-0.4 -0.0259807621135332 -0.015;-0.45 -0.2 0;-0.5 -0.0173205080756888 -0.01;-0.5 -0.0173205080756888 0.01;-0.5 -0.2 0;-0.4 0.012678547852221 0.0271892336110995;-0.4 -0.012678547852221 0.0271892336110995;-0.45 0 0.15;-0.5 -0.00845236523481399 0.018126155740733;-0.5 0.00845236523481399 0.018126155740733;-0.5 0 0.15];

rotateMatrix = [cos(targetTheta)*cos(targetPhi) cos(targetTheta)*sin(targetPhi)  -sin(targetTheta);
    sin(targetGamma)*sin(targetTheta)*cos(targetPhi)-cos(targetGamma)*sin(targetPhi)  sin(targetGamma)*sin(targetTheta)*sin(targetPhi)+cos(targetGamma)*cos(targetPhi)  sin(targetGamma)*cos(targetTheta)
    cos(targetGamma)*sin(targetTheta)*cos(targetPhi)+sin(targetGamma)*sin(targetPhi)  cos(targetGamma)*sin(targetTheta)*sin(targetPhi)-sin(targetGamma)*cos(targetPhi)   cos(targetGamma)*cos(targetTheta)];

X = X * magnifyMultiple * rotateMatrix' + [targetX,targetY,targetZ];

trisurf(TR, X(:,1),X(:,2),X(:,3),'FaceColor','blue','edgecolor',targetColor);
hold on

end
