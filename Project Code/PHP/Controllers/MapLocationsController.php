<?php
require_once '../includes/autoload.php';

/**
 * Description of MapLocationsController
 *
 * @author isaactaylor
 */
class MapLocationsController {

    private $mapLocationsModel;

    public function __construct() {
        $this->mapLocationsModel = new MapLocationsModel();
    }

    public function invokeMapLocations(MapLocations $dataObj) {
        if ($dataObj->getRequest() === Requests::locationCreation()) {
            return $this->mapLocationsModel->createMapLocations($dataObj);
        } else if ($dataObj->getRequest() === Requests::locationRequest()) {
            return $this->mapLocationsModel->readMapLocations($dataObj);
        } else if ($dataObj->getRequest() === Requests::locationUpdate()) {
            return $this->mapLocationsModel->updateMapLocations($dataObj);
        } else if ($dataObj->getRequest() === Requests::locationDeletion()) {
            return $this->mapLocationsModel->deleteMapLocations($dataObj);
        } else if ($dataObj->getRequest() === Requests::locationsReadAll()) {
            return $this->mapLocationsModel->getAllMapLocations($dataObj);
        } else {
            return FailOrPass::getFailureArray();
        }
    }

}
