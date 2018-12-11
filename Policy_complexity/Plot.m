N = 1000;
str = sprintf('Data1000');
load(str);     

plot(optimal_unrestricted_prob_set, '.')
hold on
plot(policy, '.')

% Plot approximations
t = 0:length(optimal_unrestricted_prob_set) - 1;

% Linear approximation
alpha = coeffvalues(fittedLinear);
y = alpha(1)*t + alpha(2);
plot(y)

% Exponential approximation
alpha = coeffvalues(fittedExp);
y = min((1/N)*alpha.^t, 0.5);
plot(y)
