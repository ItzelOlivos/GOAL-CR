function [optimal_policy] = QMDP(N)

    T = 5*N;
    gamma = 1;

    str = sprintf('../The_size_of_the_network_is_known/Greedy_Continuous_policies/OptimalPolicy_%d_%d', N, 1000);
    load(str)

    Iterations = 1000000;
    snap_step = 100;

    R = -1;
    States = N:-1:0;
    A = zeros(1,N-1);
    for i = 2:N
        A(i-1) = 1/i;
    end

    RMSE = zeros(1, length(Iterations));
    Alpha_vector = zeros(length(A), length(States));
    delta = N;

    for i = 1:Iterations    

        Alpha_vector_prev = Alpha_vector;
        for x = 1:length(States) - 1
            s = States(x);
            failure = (1 - s.*A.*(1-A).^(s-1)) * max(Alpha_vector(:, x));
            success = (s.*A.*(1-A).^(s-1)) * max(Alpha_vector(:, x + 1));            
            Alpha_vector(:, x) = R + gamma * (failure + success);                   
        end

        delta = sqrt(mean(mean((Alpha_vector-Alpha_vector_prev).^2)));
        RMSE(i) = delta;

        if delta < 0.000001
            break;
        end    
        if mod(i,snap_step) == 0        
            Value_func = zeros(1,T);
            optimal_policy = zeros(1,T);
            belief_state = zeros(1, length(States));

            belief_state(1) = 1;
            for t =1:T
                U = zeros(1, length(A));
                for idx_a = 1:length(A)
                    U(idx_a) = Alpha_vector(idx_a, :)* belief_state';
                end
                [Value_func(t), idx_opt_a] = max(U);
                optimal_policy(t) = A(idx_opt_a);
                a = A(idx_opt_a);

                % Updating
                prior = [0, belief_state];
                for x = 1:length(States)
                    s = States(x);
                    failure = (1 - s * a * (1 - a) ^ (s - 1)) * prior(x + 1);
                    success = ((s + 1) * a * (1 - a) ^ s) * prior(x);
                    belief_state(x) = success + failure;
                end        
            end  

            figure(1)
            subplot(3,1,1)
            surface(Alpha_vector)
            title('Alpha vectors')
            subplot(3,1,2)
            plot(optimal_policy, 'r')
            hold on
            plot(optimal_unrestricted_prob_set(1:T), 'b')
            hold off
            title('Optimal Continuous policy vs computed')
            subplot(3,1,3)
            plot(RMSE)
            title('RMSE. Press enter to continue')

            keydown = waitforbuttonpress;
            if (keydown ~= 0)
                % Save results if enter is pressed
                str = sprintf('QMDP_policies/policy_%d.mat', N);
                save(str, 'optimal_policy');   
            end        
        end    
    end                      

    Value_func = zeros(1,T);
    optimal_policy = zeros(1,T);
    belief_state = zeros(1, length(States));

    belief_state(1) = 1;
    for t =1:T
        U = zeros(1, length(A));
        for idx_a = 1:length(A)
            U(idx_a) = Alpha_vector(idx_a, :)* belief_state';
        end
        [Value_func(t), idx_opt_a] = max(U);
        optimal_policy(t) = A(idx_opt_a);
        a = A(idx_opt_a);

        % Updating
        prior = [0, belief_state];
        for x = 1:length(States)
            s = States(x);
            failure = (1 - s * a * (1 - a) ^ (s - 1)) * prior(x + 1);
            success = ((s + 1) * a * (1 - a) ^ s) * prior(x);
            belief_state(x) = success + failure;
        end        
    end

    str = sprintf('QMDP_policies/policy_%d.mat', N);
    save(str, 'optimal_policy');   