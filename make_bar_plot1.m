% making quick bar plot for 2020-12 BRF letter of intent

clear all
close all

% values for distance traveled

% controls
C(1) = 1.3e5;
C(2) = 1.53e5;

% low LAMuOR dose
L(1) = 1.32e5;
L(2) = 1.2e5;

% high LAMuOR dose
H(1) = 0.86e5;
H(2) = 0.74e5;

% calculating SEMs (silly for N=2, but whatever)
SEM_C = sem(C, 2);
SEM_L = sem(L, 2);
SEM_H = sem(H, 2);


% plotting
f1 = figure('Renderer', 'painters');
a1 = axes;

p1 = bar(1, mean(C));
hold on
p2 = bar(2, mean(L));
p3 = bar(3, mean(H));

p1.EdgeAlpha = 0;
p2.EdgeAlpha = 0;
p3.EdgeAlpha = 0;

e1 = errorbar([1, 2, 3], [mean(C), mean(L), mean(H)], ...
    [SEM_C, SEM_L, SEM_H]);
e1.LineWidth = 1.5;
e1.Color = [0 0 0];

%%
a1.YTick = [];
a1.XTick = [];
xlabel('control, low LAMuOR, high LAMuOR');
ylabel('Distance traveled');
% H = sigstar({[2,3], [1,3], [1,2]}, [0.04, 0.04, nan]);

H1 = sigstar([1,2], nan);

[h,p] = ttest2(L, H);
H2 = sigstar([2,3], p);

[h,p] = ttest2(C, H);
H3 = sigstar([1,3], p);



