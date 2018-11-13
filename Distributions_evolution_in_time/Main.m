% ----------------------------------------------------------------------
% -- GOAL-CR computes the sequence of access probabilities that 
% -- minimizes the expected contention resolution time.
% ----------------------------------------------------------------------

% --------------------------- Input params -----------------------------
% -- Size of the network, ie, number of active nodes at time slot t
N = 50;
T = 5 * N;
% -- Compare the performance against alternative protocols
% -- (1) Fixed optimal probability 
% -- (2) Random 
% -- (3) Mode 
versus = 1;

% -- Set B includes the access probabilites would use if they knew the
% -- the exact number of active nodes.
num_nodes = N+1:-1:0;
B = zeros(1, N-1);
for i = 0:1:N-2
    B(i + 1) = 1/(N - i);
end

% --------------------- Begin pre-processing ---------------------------
if versus == 1
    versus_alg = 'Fixed Tau Algorithm';        
elseif versus == 2        
    versus_alg = 'Random Tau Algorithm';
else
    versus_alg = 'Tau  = Inverse of Expected number of active nodes';
end        
% ------------------------ Config. initial belief ----------------------
distribution = zeros(N + 2, 2);
greedy_prob_set = zeros(1, T);

vs_distribution = zeros(N + 2, 2);
versus_prob_set = zeros(1, T);

distribution(1,1) = 0;
distribution(2,1) = 1;

vs_distribution(1,1) = 0;
vs_distribution(2,1) = 1;

% --------- Expected number of active nodes al time slot t --------------
EKprev_greedy = N;
EKprev_versus = N;
% ---- Probability of successful resource acquisition at time slot t ----
EQcurrent_greedy = 0;
EQcurrent_versus = 0;
fixed = ComputeConstantOptimal(N);        
% -------------------- Begin ploting distributions ----------------------
figure (1)
t = 0;
while t <= T          
    Ecurrent_greedy = EKprev_greedy - EQcurrent_greedy;
    subplot(2,1,1)    
    bar(num_nodes, distribution(:,1), 'r')   
    str = sprintf('Probability distribution of active nodes at time t = %d', t);
    title(str)
    str = sprintf('E[A] = %f', Ecurrent_greedy);
    ylabel(str)
    xlabel('GOAL-CR')
    xlim([-10 N+10])

    Ecurrent_versus = EKprev_versus - EQcurrent_versus;
    subplot(2,1,2)
    bar(num_nodes, vs_distribution(:,1), 'y')   
    str = sprintf('Probability distribution of active nodes at time t = %d', t);
    title(str)
    str = sprintf('%s', versus_alg);
    xlabel(str)
    str = sprintf('E[A] = %f', Ecurrent_versus);
    ylabel(str)
    xlim([-10 N+10])

    pause(0.001)
    
    t = t + 1;
    
    % ---------------------------- Greedy -------------------------------
    % ------------------ Compute current distribution -------------------
    [p, EQcurrent_greedy] = get_greedy(N, num_nodes, B, distribution);
    for n = 2:N + 2
        j = num_nodes(n);
        A1 = (1 - j*p*(1-p)^(j-1)) * distribution(n, 1);
        B1 = ((j+1)*p*(1-p)^j) * distribution(n - 1, 1);
        distribution(n,2) = A1 + B1;
    end
    greedy_prob_set(t) = p;
    % ---------------------- Compute Expectation ------------------------
    EKprev_greedy = 0;
    for n = 2:N + 2
        j = num_nodes(n);
        EKprev_greedy = EKprev_greedy + j * distribution(n, 2);
    end
    % ------------- Update previous distribution = current --------------
    distribution(:,1) = distribution(:,2);
    distribution(:,2) = 0;     

%     % ---------------------------- Versus -------------------------------
%     % ---------------- Compute current distribution ---------------------
    [p, EQcurrent_versus] = get_versus(N, num_nodes, B, vs_distribution, versus, Ecurrent_versus, fixed);        
    for n = 2:N + 2
        j = num_nodes(n);
        A1 = (1 - j*p*(1-p)^(j-1)) * vs_distribution(n, 1);
        B1 = ((j+1)*p*(1-p)^j) * vs_distribution(n - 1, 1);
        vs_distribution(n,2) = A1 + B1;
    end
    versus_prob_set(t) = p; 
    % ----------------------- Compute Expectation -----------------------
    EKprev_versus = 0;
    for n = 2:N + 2
        j = num_nodes(n);
        EKprev_versus = EKprev_versus + j * vs_distribution(n, 2);
    end

    % ------------ Update previous distribution = current ---------------
    vs_distribution(:,1) = vs_distribution(:,2);
    vs_distribution(:,2) = 0;    
end
