filename = '/home/hkh-explore/disk2/logdir/gym_moab_022022_hor10rss8/m8/dreamerv2/1/variables.pkl'
import tensorflow as tf 
import common
import ruamel.yaml as yaml
import pathlib
import agent
import functools

steps = 10 #?

def make_env():
    task ='Moab-v0' 
    env = common.GymWrapper(task)
    env = common.NormalizeAction(env)
    return env

configs = yaml.safe_load((
      pathlib.Path(sys.argv[0]).parent / 'configs.yaml').read_text())
parsed, remaining = common.Flags(configs=['defaults']).parse(known_only=True)
config = common.Config(configs['defaults'])
env = make_env()
for name in parsed.configs:
    config = config.update(configs[name])
    config = common.Flags(config).parse(remaining)
agnt = agent.Agent(config, env.obs_space, env.act_space, steps)
agnt.load(filename)
