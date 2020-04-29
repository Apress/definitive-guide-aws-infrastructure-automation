

class Inputs:
    
    def __init__(self):
        pass


    def _get_ck(self):
        return self.scope.node.try_get_context(self.key)


    def _param_get_default(self):
        if self.key in self.scope.node.try_get_context('Defaults'):
            return self.scope.node.try_get_context('Defaults')[self.key]
        else:
            return self._get_ck()


    def _param_validate(self):
        if self.key in self.scope.node.try_get_context('AllowedValues'):
            if self._get_ck() in self.scope.node.try_get_context('AllowedValues')[self.key]:
                return True
            else:
                return False
        else:
            return True


    def get(self, scope, key):
        self.scope = scope
        self.key = key
        return self._get_ck() if (self._get_ck() and self._param_validate()) else self._param_get_default()

