import xverifysdk

class NfcEidReadService {
    func nfcEidRead(eid: Eid) {
        ONBOARDDATAMANAGER.eid = eid
    }
}
