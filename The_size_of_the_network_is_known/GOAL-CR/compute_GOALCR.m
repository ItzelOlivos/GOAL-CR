function [policy] = compute_GOALCR(N)

    % dist = get_distribution(N, ps);
    % ---------------------- Compute policies --------------------------
    prob_set = zeros(1, N-1);
    for i = 0:1:N-2
        prob_set(i + 1) = 1/(N - i);
    end

    T = 5*N;

    distribution = zeros(N+1, 2);
    distribution(N+1,1) = 1;

    optimal_prob_set = zeros(1, T);

    % -------------------- Start looping up T ---------------------
    t = 1;
    while t <= T
        if mod(t,100) == 0
            t
        end
        % ---------------- Take greedy choice ---------------------
        p = get_next_p(prob_set, distribution(:, 1));

        % --------------- Compute current distribution ------------
        for j = length(distribution(:, 1))-1:-1:1
            A = (1 - j*p*(1-p)^(j-1)) * distribution(j, 1);
            B = ((j+1)*p*(1-p)^j) * distribution(j+1, 1);
            distribution(j,2) = A + B;
        end
        optimal_prob_set(t) = p;
        % ------------------ Update Expectation -------------------

        distribution(:,1) = distribution(:,2);
        distribution(:,2) = 0;

        t = t + 1;
    end

    policy = optimal_prob_set;

    str = sprintf('GOAL-CR/OptimalPolicy_%d', N);
    save(str, 'policy');
