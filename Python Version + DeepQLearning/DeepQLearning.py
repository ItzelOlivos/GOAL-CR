"""
Using DDPG (stable baselines):
In the sample implementation, they solve the classic Pendulum problem:
    Observations: [x, y, angular velocity] -> 3 continuous numbers
    Actions: Torque -> Single number between -2 to 2
    Rewards: r = -(theta<sup>2</sup> + 0.1 * theta_dt<sup>2</sup> + 0.001 * torque<sup>2</sup>) where theta is the pendulum's angle normalized between [-pi, pi]

Idea to solve the problem:
    States: Single number (n) indicating the current amount of active nodes
    Actions: single number (p) indicating the probability of tx
    Observation (input to network): beliefs (N-D vectors: PDF describing the number of active nodes)
    E[Rewards]: ?

"""

import tensorflow as tf
from tensorflow import keras
from collections import deque
import random
import numpy as np


class Environment:
    def __init__(self, N):
        self.s = N
        self.t = 0

    def step(self, a):
        r = -1
        done = False
        comm_attempts = np.random.binomial(1, a, self.s)
        if sum(comm_attempts) == 1:
            # Successful communication
            self.s -= 1
            if self.s == 0:
                r = 100
                done = True
        self.t += 1
        return r, done


RANDOM_SEED = 5
tf.random.set_seed(RANDOM_SEED)

train_episodes = 300
test_episodes = 100

N = 50
A = np.array([1/(i + 1) for i in range(N)])
S = np.arange(N+1)


def architecture(state_shape, action_shape):
    """ The Neural network maps  belief states to actions
    """
    learning_rate = 0.001
    init = tf.keras.initializers.HeUniform()
    model = keras.Sequential()
    model.add(keras.layers.Dense(24, input_shape=state_shape, activation='relu', kernel_initializer=init))
    model.add(keras.layers.Dense(12, activation='relu', kernel_initializer=init))
    model.add(keras.layers.Dense(action_shape, activation='linear', kernel_initializer=init))
    model.compile(loss=tf.keras.losses.Huber(), optimizer=tf.keras.optimizers.Adam(learning_rate=learning_rate), metrics=['accuracy'])
    return model


def get_qs(model, state, step):
    return model.predict(state.reshape([1, state.shape[0]]))[0]


def train(env, replay_memory, model, target_model, done):
    learning_rate = 0.7
    # discount_factor = 0.618
    discount_factor = 1.

    MIN_REPLAY_SIZE = 1000
    if len(replay_memory) < MIN_REPLAY_SIZE:
        return

    batch_size = 64 * 2
    mini_batch = random.sample(replay_memory, batch_size)
    current_states = np.array([transition[0] for transition in mini_batch])
    current_qs_list = model.predict(current_states)
    new_current_states = np.array([transition[3] for transition in mini_batch])
    future_qs_list = target_model.predict(new_current_states)

    X = []
    Y = []
    for index, (observation, action, reward, new_observation, done) in enumerate(mini_batch):
        if not done:
            max_future_q = reward + discount_factor * np.max(future_qs_list[index])
        else:
            max_future_q = reward

        current_qs = current_qs_list[index]
        current_qs[action] = (1 - learning_rate) * current_qs[action] + learning_rate * max_future_q

        X.append(observation)
        Y.append(current_qs)
    model.fit(np.array(X), np.array(Y), batch_size=batch_size, verbose=0, shuffle=True)


def belief_updating(b, a):
    b[0] = (a * (1 - a)**0) * b[1]
    for i in range(1, N):
        b[i] = (1 - i * a * (1 - a)**(i - 1)) * b[i] + ((i + 1) * a * (1 - a)**i) * b[i+1]
    b[N] = (1 - i * a * (1 - a)**(N - 1)) * b[N]
    return b


def main():
    epsilon = 1         # Epsilon-greedy algorithm. At the beginning the best action is selected at random
    max_epsilon = 1     # Agent explores at most 100% of the time
    min_epsilon = 0.01  # Agent explores at least 1% of the time
    decay = 0.01

    # 1. Initialize the Target and Main models
    # Main Model (updated every 4 steps)
    model = architecture(S.shape, A.shape[0])

    # Target Model (updated every 100 steps)
    target_model = architecture(S.shape, A.shape[0])
    target_model.set_weights(model.get_weights())

    replay_memory = deque(maxlen=50_000)
    target_update_counter = 0

    # X = states, y = actions
    X = []
    y = []

    steps_to_update_target_model = 0

    for episode in range(train_episodes):
        total_training_rewards = 0
        env = Environment(N)
        done = False
        belief = np.zeros(N+1)
        belief[N] = 1
        while not done:
            steps_to_update_target_model += 1
            # 2. Explore using the Epsilon Greedy Exploration Strategy
            if np.random.rand() <= epsilon:
                # Explore
                idx_action = np.random.randint(A.shape[0])
            else:
                # Exploit best known action
                encoded = belief
                encoded_reshaped = encoded.reshape([1, encoded.shape[0]])
                predicted = model.predict(encoded_reshaped).flatten()
                idx_action = np.argmax(predicted)

            reward, done = env.step(A[idx_action])
            new_belief = belief_updating(belief, A[idx_action])
            e_reward = -1 + 101 * new_belief[0]
            replay_memory.append([belief, idx_action, e_reward, new_belief, done])

            # 3. Update the Main Network using the Bellman Equation
            if steps_to_update_target_model % 4 == 0 or done:
                train(env, replay_memory, model, target_model, done)

            belief = new_belief
            total_training_rewards += e_reward

            if done:
                print('Total training rewards: {} after n steps = {} with final reward = {}'.format(total_training_rewards, episode, reward))
                total_training_rewards += 1

                if steps_to_update_target_model >= 100:
                    print('Copying main network weights to the target network weights')
                    target_model.set_weights(model.get_weights())
                    steps_to_update_target_model = 0
                break

        epsilon = min_epsilon + (max_epsilon - min_epsilon) * np.exp(-decay * episode)


if __name__ == '__main__':
    main()