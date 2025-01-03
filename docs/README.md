# BIO Compliancy initiative template opbouw

De template is opgebouwd door controls uit het Cloud thema BIO te mappen naar Azure policies aanwezig in het Microsoft Azure platform. Door deze opzet zullen toekomstige updates die op bestaande Azure policies plaatsvinden automatisch doorgevoerd worden.

De mapping van de Azure policies die gebruikt voor deze template zijn beschikbaar in [BIO Control Policy mapping excel](./Data-policy-mapping%20v2.2.3.xlsx)

Deze template is gebaseerd op BIO Thema-uitwerking Clouddiensten versie 2.2 en het KPMG BIO coverage - Final report document number A2000019790 report.
Meer informatie hierover vind u op: [CIP overheid Cloud thema](https://cip-overheid.nl/productcategorieen-en-workshops/producten?product=Clouddiensten) of op verzoek bij u Microsoft contact persoon.

## Implementeren op Azure

Het implementeren van de template kan op 2 niveaus:

- Op management group niveau; aanbevolen voor Enterprise en grotere implementaties.
- Op subscription niveau; aanbevolen voor testen of kleinere implementaties.

Om de template te implementeren op management group niveau kunnen additionele rechten vereist zijn.
Meer informatie hierover vind u op: [Toegang verhogen](https://docs.microsoft.com/nl-nl/azure/role-based-access-control/elevate-access-global-admin)

| Versie | Doel | Implementeer | Update bestaande policy |
|---|---|---|---|
| 2.2.4 | Management group level | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FBio-Compliancy%2Fmain%2FARM%2FBIO-azuredeploy.json) | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FBio-Compliancy%2Fmain%2FARM%2FBIO-azuredeploy-update.json) |
| 2.2.4 | Subscription level | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FBio-Compliancy%2Fmain%2FARM%2FBIO-azuredeploy-subscription.json) |  [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FBio-Compliancy%2Fmain%2FARM%2FBIO-azuredeploy-subscription-update.json) |

Gebruik de eerste button onder `Implementeer` voor de eerste keer deployments en de `Update bestaande policy` button om reeds deployde oudere versies te updaten. De laatste is ivm met bestaande vervallen parameters te kunnen updaten.
Zie voor updates de [release notes](./updates.md)

Na de implementatie van de initiative template die deze toegewezen te worden aan een Azure abonnement.
Dit gebeurt automatisch indien gekoppeld door een Management group of handmatig door toewijzing aan een Azure abonnement.

## Toevoegen nalevingsbeleid in Defender for Cloud

Het dashboard voor naleving van regelgeving toont uw geselecteerde nalevingsstandaarden met alle vereisten, waarbij ondersteunde vereisten worden toegepast op toepasselijke beveiligingsevaluaties. De status van deze evaluaties weerspiegelt uw naleving van de standaard.

> ⚠️ Na het toevoegen van initiative template en het koppelen aan de subscriptions kan het tot 24 uur duren voordat deze in het dashboard voor naleving van regelgeving wordt getoond.

Gebruik het dashboard voor naleving van regelgeving om uw aandacht te richten op de hiaten in de naleving van uw gekozen standaarden en voorschriften. Deze gerichte weergave stelt u ook in staat om uw naleving gedurende een periode continu te bewaken binnen dynamische cloud- en hybride omgevingen.

Selecteer naleving van regelgeving in het menu van Defender for Cloud.

Bovenaan het scherm ziet u een dashboard met een overzicht van uw nalevingsstatus en de set ondersteunde nalevingsvoorschriften. U ziet uw algemene nalevingsscore en het aantal door te geven versus mislukte evaluaties die aan elke standaard zijn gekoppeld.

## Implementatie stappen nalevings dashboard

Selecteer een tabblad voor een nalevingsstandaard die voor u relevant is (1). Indien de gewenste standaard niet zichtbaar is klikt u op de 3 punten.

U ziet op welke abonnementen de standaard wordt toegepast (2) en de lijst met alle besturingselementen voor die standaard (3).

Voor de toepasselijke besturingselementen kunt u de details bekijken van het doorgeven en mislukken van evaluaties die zijn gekoppeld aan dat besturingselement (4) en het aantal betrokken resources (5).

Sommige besturingselementen zijn grijs weergegeven. Aan deze besturingselementen zijn geen Evaluaties van Defender for Cloud gekoppeld. Controleer hun vereisten en beoordeel ze in uw omgeving. Sommige hiervan kunnen procesgerelateerd zijn in plaats van technisch.

Meer informatie hierover vind u op: [Uw regelnaleving verbeteren](https://docs.microsoft.com/nl-nl/azure/defender-for-cloud/regulatory-compliance-dashboard)

![alt text](https://github.com/Azure/Bio-Compliancy/blob/main/media/BIO-compliancy-12345.png?raw=true "BIO compliancy steps")

## Andere topics

De BIO-beleidsregel is ook beschikbaar in het Engelse als build-in policy. Deze kan tijdelijk verschillen van deze repository. Er is een plan om de Engelse build-in initiative te laten vervangen door deze repository, maar momenteel kan er nog gekozen worden tussen de Nederlandse versie van deze repository en de Engelse build-in versie.

Voor het maken van rapportages kijk naar bijv [azure-compliance-workbooks](https://github.com/Eurofiber-CloudInfra/azure-compliance-workbooks/) gemaakt door een partner.



