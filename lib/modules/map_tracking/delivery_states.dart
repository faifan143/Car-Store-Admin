abstract class DeliveryStates {}

class DeliveryInitialState extends DeliveryStates {}

class DeliveryGottenSuccessfully extends DeliveryStates {}

class DeliveryGottenUnSuccessfully extends DeliveryStates {}

class UpdatingCurrentLocation extends DeliveryStates {}
