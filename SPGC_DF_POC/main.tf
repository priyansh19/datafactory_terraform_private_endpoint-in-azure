module "datafactory_private_endpoint" {
    source = "./modules/DF_PE"
    resource_group_name = "POC_DF_RG_01"
    resource_group_location = "eastus2"
    virtual_network_name = "ais-poc-vnet_01"
    subnet_name = "ais-poc-subnet_01"
    data_factory_name = "ais-poc-df-test-02"
    private_endpoint_name = "ais-poc-df-pe_01"
    private_endpoint_portal_name = "ais-poc-df-portal-pe_01"
}