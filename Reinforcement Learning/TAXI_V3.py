from collections import deque, defaultdict
import math
import numpy as np
import matplotlib.pyplot as plt
import gym

REWARD = []

class QLearning_Agent:
    def __init__(self, alpha, decaylimit=False):
        """ Initialize agent.

        Params
        ======
        - nA: number of actions available to the agent
        """
        self.env = gym.make('Taxi-v3')
        self.actionsize = self.env.action_space.n
        self.Q = defaultdict(lambda: np.zeros(self.actionsize))
        self.episodes = 20000
        self.memorylength = 100
        self.epsilon = 1
        self.decay = 0.9999
        self.decaylimit = decaylimit
        self.starttrain = 100
        self.alpha = alpha
        self.gamma = 1

    def act(self, state):
        """ Given the state, select an action.

        Params
        ======
        - state: the current state of the environment

        Returns
        =======
        - action: an integer, compatible with the task's action space
        """
        # Update Epsilon (based on different epsilon strategies)
        if (self.decaylimit):
            self.epsilon = max(self.epsilon * self.decay, 0.01)
        else:
            self.epsilon *= self.decay

        # Set up epsilon greedy policy
        ka = []
        kp = []
        for i in range(self.actionsize):
            ka.append(i)
            kp.append(self.epsilon / self.actionsize)
        index = np.argmax(self.Q[state])
        kp[index] += 1 - self.epsilon

        # Select action based on epsilon greedy policy
        return np.random.choice(np.array(ka), p=np.array(kp))

    def step(self, state, action, reward, next_state, done):
        """ Update the agent's knowledge, using Sarsa and the most recently sampled tuple.

        Params
        ======
        - state: the previous state of the environment
        - action: the agent's previous choice of action
        - reward: last reward received
        - next_state: the current state of the environment
        - done: whether the episode is complete (True or False)
        """
        # Q-Learning off policy solution with constant learning rate
        self.Q[state][action] = (1 - self.alpha) * self.Q[state][action] + self.alpha * (
                    reward + self.gamma * np.max(self.Q[next_state]))

    def train(self):
        """ Monitor agent's performance.

        Params
        ======
        - env: instance of OpenAI Gym's Taxi-v1 environment
        - agent: instance of class Agent (see Agent.py for details)
        - num_episodes: number of episodes of agent-environment interaction
        - window: number of episodes to consider when calculating average rewards

        Returns
        =======
        - avg_rewards: deque containing average rewards
        - best_avg_reward: largest value in the avg_rewards deque
        """
        # initialize average rewards
        average = deque(maxlen=self.episodes)
        # initialize best average reward
        bestone = -math.inf
        # initialize monitor for most recent rewards
        sample = deque(maxlen=self.memorylength)
        # for each episode
        for e in range(1, self.episodes + 1):
            done = False
            # begin the episode
            state = self.env.reset()
            # initialize the sampled reward
            i = 0
            while not done:
                # agent selects an action
                action = self.act(state)
                # agent performs the selected action
                next_state, reward, done, _ = self.env.step(action)
                # agent performs internal updates based on sampled experience
                self.step(state, action, reward, next_state, done)
                i += reward
                # update the sampled reward
                # update the state (s <- s') to next time step
                state = next_state
            sample.append(i)

            if (e >= self.starttrain):
                # get average reward from last 100 episodes
                avg = np.mean(sample)
                # append to deque
                average.append(avg)
                # update best average reward
                if avg > bestone:
                    bestone = avg
                # monitor progress
                print(f"The best reward by the {e}/{self.episodes} episodes is {bestone} ")
                # check if task is solved (according to OpenAI Gym)
                if bestone >= 9.7:
                    print('mission accomplish')
                    break
            if e == self.episodes: print('\n')
        k = []
        for i in range(len(average)):
            k.append(i)
        plt.figure()
        plt.title('history')
        plt.plot(k, average)
        plt.xlabel('step')
        plt.ylabel('reward')
        plt.show()
        return average, bestone


qlearning_agent = QLearning_Agent(0.1)
qlearning_avg_rewards, _ = qlearning_agent.train()
