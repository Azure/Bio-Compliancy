# BIO Compliancy initiative template opbouw

Dit project omvat een intiative policy template welke ingeladen kan worden in Microsoft Azure en in combinatie met Defender for Cloud kan auditen of de resources in de Azure omgeving voldoen aan de BIO compliany.


Deze template is gebaseerd op BIO Thema-uitwerking Clouddiensten versie 2.1.
Meer informatie hierover vind u op: [CIP overheid Cloud thema](https://cip-overheid.nl/productcategorie%C3%ABn-en-worshops/producten/bio-en-thema-uitwerkingen/#Clouddiensten/) 

Voor de leesbaarheid en technische implementatie zijn de titels van de controls in deze template herschreven. Voor een volledige beschrijving van deze controls wordt verwezen naar de bovenstaande link op de website van het CIP overheid.

## Implementeren op Azure

| Versie | Doel | Implementeer |
|---|---|---|
| 2.1.0 | Management group level | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FBio-Compliancy%2Fmain%2FARM%2FBIO-azuredeploy.json) |
| 2.1.0 | Subscription level | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FBio-Compliancy%2Fmain%2FARM%2FBIO-azuredeploy.json) |

## Toevoegen nalevingsbeleid in Defender for Cloud

Het dashboard voor naleving van regelgeving toont uw geselecteerde nalevingsstandaarden met alle vereisten, waarbij ondersteunde vereisten worden toegepast op toepasselijke beveiligingsevaluaties. De status van deze evaluaties weerspiegelt uw naleving van de standaard.

Gebruik het dashboard voor naleving van regelgeving om uw aandacht te richten op de hiaten in de naleving van uw gekozen standaarden en voorschriften. Deze gerichte weergave stelt u ook in staat om uw naleving gedurende een periode continu te bewaken binnen dynamische cloud- en hybride omgevingen.

Selecteer naleving van regelgeving in het menu van Defender for Cloud.

Bovenaan het scherm ziet u een dashboard met een overzicht van uw nalevingsstatus en de set ondersteunde nalevingsvoorschriften. U ziet uw algemene nalevingsscore en het aantal door te geven versus mislukte evaluaties die aan elke standaard zijn gekoppeld.

Selecteer een tabblad voor een nalevingsstandaard die voor u relevant is (1). U ziet op welke abonnementen de standaard wordt toegepast (2) en de lijst met alle besturingselementen voor die standaard (3). Voor de toepasselijke besturingselementen kunt u de details bekijken van het doorgeven en mislukken van evaluaties die zijn gekoppeld aan dat besturingselement (4) en het aantal betrokken resources (5). Sommige besturingselementen zijn grijs weergegeven. Aan deze besturingselementen zijn geen Evaluaties van Defender for Cloud gekoppeld. Controleer hun vereisten en beoordeel ze in uw omgeving. Sommige hiervan kunnen procesgerelateerd zijn in plaats van technisch.

![alt text](https://github.com/Azure/Bio-Compliancy/blob/main/media/BIO-compliancy-example.png?raw=true "BIO compliancy example")
