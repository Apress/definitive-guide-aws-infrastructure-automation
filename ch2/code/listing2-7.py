from sceptre.hooks import Hook


class CustomHook(Hook):
    def __init__(self, *args, **kwargs):
        super(CustomHook, self).__init__(*args, **kwargs)

    def run(self):
        """
        run is the method called by Sceptre. It should carry out the work
        intended by this hook.

        self.argument is available from the base class and contains the
        argument defined in the Sceptre config file (see below)

        The following attributes may be available from the base class:
        self.stack_config  (A dict of data from <stack_name>.yaml)
        self.stack.stack_group_config  (A dict of data from config.yaml)
        self.connection_manager (A connection_manager)
        """
        print(self.argument)
