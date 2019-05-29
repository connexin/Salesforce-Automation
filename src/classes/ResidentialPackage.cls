public class ResidentialPackage {
    
    String name { get; set; }
    String downloadSpeed { get; set; }
    String uploadSpeed { get; set; }
    String monthUsage { get; set; }
    String contractLength { get; set; }
    
    public ResidentialPackage(final String name,
                              final String downloadSpeed,
                              final String uploadSpeed,
                              final String monthUsage,
                              final String contractLength) {
                                  this.name = name;
                                  this.downloadSpeed = downloadSpeed;
                                  this.uploadSpeed = uploadSpeed;
                                  this.monthUsage = monthUsage;
                                  this.contractLength = contractLength;
                              }

}