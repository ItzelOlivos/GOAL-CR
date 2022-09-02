from matplotlib.animation import FuncAnimation
from matplotlib import animation
import matplotlib.pyplot as plt
import gym
import numpy as np

N = 100

# =============== Greedy strategy ===============
b0 = np.zeros(N+1)
b0[N] = 1
final_rwd = 10

env = gym.make("gym_basic:wireless-v0")
env.customize(N, b0, final_rwd)

t = 0
done = False
belief = env.reset()
R = 0
a_space = [0.99999999] + [1/i for i in range(2, N+1)]
beliefs_story = []
states = np.arange(N+1)

bel_max = 0
action = 1/N
while not done:
    belief, rwd, done, _ = env.step(action)
    # Action that maximizes prob of successful tx
    adx = np.argmax([sum([(i * a * (1-a)**(i-1))*belief[i] for i in range(N+1)]) for a in a_space])
    action = a_space[adx]
    R += rwd
    t += 1
    beliefs_story.append(belief)
    local_max = np.max(belief)
    if local_max > bel_max:
        bel_max = local_max

# =============== Fixed strategy ===============
b0 = np.zeros(N+1)
b0[N] = 1
final_rwd = 10

env = gym.make("gym_basic:wireless-v0")
env.customize(N, b0, final_rwd)

t = 0
done = False
belief = env.reset()
R = 0
fixed_action = 1/N
beliefs_story_v2 = []

while not done:
    belief, rwd, done, _ = env.step(fixed_action)
    # Action that maximizes prob of successful tx
    R += rwd
    t += 1
    beliefs_story_v2.append(belief)
    local_max = np.max(belief)
    if local_max > bel_max:
        bel_max = local_max

# 15 -  900
#       500

def create_demo(vars):
    # ================= Setting subplots ===================
    my_dpi = 326
    fig, ax = plt.subplots(1, 1, figsize=(12, 7))

    def clear():
        ax.clear()
        ax.set_ylim([0, 0.3])
        # Set ax settings

    def animate(t):
        clear()
        ax.bar(states, beliefs_story_v2[t], color="silver", alpha=0.7, label="fixed strategy")
        ax.bar(states, beliefs_story[t], color="royalblue", alpha=0.7, label="GOAL-CR")
        ax.set_xlabel('number of active sensors')
        ax.set_ylabel('probability')
        ax.legend(ncol=3, loc='upper right')

    clear()
    anim = FuncAnimation(
        fig,
        animate,
        frames=len(beliefs_story),
        interval=1,
        blit=False,
        repeat=False
    )

    plt.show()

    return anim


anim = create_demo(None)

f = r"animation-goal.gif"
writergif = animation.PillowWriter(fps=6)
anim.save(f, writer=writergif)