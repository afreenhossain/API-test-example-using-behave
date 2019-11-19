from environs import Env

ENV = Env()
ENV.read_env()


class Config:
    """Configurations reading from environment file."""

    def __init__(self):
        self.base_url = ENV('BASE_URL')


CONFIG = Config()
