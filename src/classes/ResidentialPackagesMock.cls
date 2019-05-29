public class ResidentialPackagesMock {

    public List<ResidentialPackage> packages;

    public ResidentialPackagesMock() {
        packages = new List<ResidentialPackage>();
        
        packages.add(new ResidentialPackage('Essential',
                                            '10 Mbps download',
                                            '10 Mbps upload',
                                            '100 GB allowance',
                                            '18 Months'));
        packages.add(new ResidentialPackage('Extra',
                                            '20 Mbps download',
                                            '20 Mbps upload',
                                            'Unlimited',
                                            '18 Months'));
        packages.add(new ResidentialPackage('Extreme',
                                            '60 Mbps download',
                                            '60 Mbps upload',
                                            'Unlimited',
                                            '18 Months'));
    }
}