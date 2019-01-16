function [optimal_policy] = Q_learning(Nodes)

    T = 5*Nodes;

    str = sprintf('../The_size_of_the_network_is_known/GOAL-CR/OptimalPolicy_%d', Nodes);
    load(str)
    
    if T > length(policy)
        added = policy(end)*ones(1, T-length(policy));
        policy = [policy, added];
    end

    States = 1:T;
    Actions = zeros(1, Nodes-1);
    for i = 2:Nodes
        Actions(i-1) = 1/i;
    end
    flip(Actions);

    alpha_min = 60;         % Min Learning rate = alpha_min/10, that should be high for rare pairs (Best observed 60)
    gamma = 1;              % Discount rate, used for non episodic tasks
    Ne = 10;                % Minimum amount of visists per pair
    Rplus = T;              % Optimistic estimate of the best possible reward obtainable in any state
    Iterations = 100000;
    snap_step = 1000;

    Q = normrnd(0, 1, [length(States), length(Actions)]);
    Nsa = zeros(length(States), length(Actions));

    optimal_policy = zeros(1, T);

    RMSE = zeros(1, length(Iterations));

    for t = 1:Iterations
        tmpQ = Q;         

        k = Nodes;
        s = 1;        
        exploratory_func = zeros(1, length(Actions));
        for arg = 1:length(Actions)
            u = Q(s + 1, arg);
            n = Nsa(s + 1, arg);
            if n < Ne
                exploratory_func(arg) = Rplus;
            else
                exploratory_func(arg) = u;
            end
        end
        [v, arg] = max(exploratory_func);   
        a = Actions(arg);

        for s = 1:T  
            Nsa(s, arg) = Nsa(s, arg) + 1;            

            % Simulate to define reward
            r = 0;        
            if k > 0
                wanting = 0;
                for j = 1:k
                    p = rand();
                    if p < a
                        wanting = wanting + 1;
                    end
                    if wanting > 1
                        break
                    end
                end
                if wanting == 1
                    k = k - 1;                     
                end            
            end          
            if s == T || k == 0
                if k == 0
                    r = (T - s)*100;
                else
                    r = -k;                
                end
                Q(s, :) = r;                                                
                break
            else     
                [max_value, max_arg] = max(Q(s + 1, :));
                % alpha sets higher utility estimate to relativeley un explored states
                alpha_func = alpha_min/(alpha_min - 1 + Nsa(s + 1, max_arg));            
                Q(s, arg) = Q(s, arg) + alpha_func*(r + gamma*max_value - Q(s, arg));

                exploratory_func = zeros(1, length(Actions));
                for next_arg = 1:length(Actions)
                    u = Q(s + 1, next_arg);
                    n = Nsa(s + 1, next_arg);
                    if n < Ne
                        exploratory_func(next_arg) = Rplus;
                    else
                        exploratory_func(next_arg) = u;
                    end
                end            
                [v, arg] = max(exploratory_func);
                a = Actions(arg);                                                                       
            end            
        end        
        delta = sqrt(mean(mean((Q-tmpQ).^2)));    
        RMSE(t) = delta;  

        if delta < 0.0001
            break;
        end    
        if mod(t,snap_step) == 0
            for s = 1:T
                [val, arg] = max(Q(s, :));
                optimal_policy(s) = Actions(arg);    
            end
            figure(1)
            subplot(2,2,1)
            plot(optimal_policy)
            hold on
            plot(policy(1:T))
            hold off
            str = sprintf('Greedy policy vs computed at iteration %d', t);
            title(str)            

            subplot(2,2,2)
            plot(RMSE)
            title('RMSE')
            
            subplot(2,2,3)
            surface(Nsa')
            title('Number of visits to state-action pairs')
            
            subplot(2,2,4)
            surface(Q')
            title('Q values. Press enter to continue')

            keydown = waitforbuttonpress;
            if (keydown ~= 0)
                % Save results if enter is pressed
                trial = t;
                str = sprintf('QLearning_policies/policy_%d.mat', Nodes);
                save(str, 'optimal_policy', 'Q', 'Nsa', 'RMSE', 'Ne', 'Rplus', 'alpha_min');
                break
            end

        end
    end

    for s = 1:T
        [val, arg] = max(Q(s, :));
        optimal_policy(s) = Actions(arg);    
    end

    figure(1)
    subplot(2,2,1)
    plot(optimal_policy)
    hold on
    plot(policy(1:T))
    hold off
    str = sprintf('Greedy policy vs computed at iteration %d', t);
    title(str)            

    subplot(2,2,2)
    plot(RMSE)
    title('RMSE')

    subplot(2,2,3)
    surface(Nsa')
    title('Number of visits to state-action pairs')

    subplot(2,2,4)
    surface(Q')
    trial = t;
    title('Q values. Press enter to continue')
    
    str = sprintf('QLearning_policies/policy_%d.mat', Nodes);
    save(str, 'optimal_policy', 'Q', 'Nsa', 'RMSE', 'Ne', 'Rplus', 'alpha_min');