public class ConnectedDevice {
    public Id managementIP {get;set;}
    public Id managementDevice {get;set;}
    public Id devicePortAssignment {get;set;}
    public Id portAssignment {get;set;}
    public String name {get;set;}
    public String description {get;set;}
    public String connectedDevice {get;set;}
    
    public ConnectedDevice(Id managementIP, Id managementDevice, Id devicePortAssignment, String name) {
        this.managementIP = managementIP;
        this.managementDevice = managementDevice;
        this.devicePortAssignment = devicePortAssignment;
        this.name = name;
        this.description = description;
        this.connectedDevice = connectedDevice;
    }
    
    public ConnectedDevice (Id portAssignment, String name, String description, String connectedDevice) {
        this.portAssignment = portAssignment;
        this.name = name;
        this.description = description;
        this.connectedDevice = connectedDevice;
    }
}