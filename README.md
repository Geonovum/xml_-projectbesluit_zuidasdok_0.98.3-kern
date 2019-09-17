
**Stappen:

1. Transformatie file "Projectbesluit nieuw_0.91.xml door map.xsl ==> output ProjectBesluit_1_map.xml
2. Transformatie file "ProjectBesluit_1_map.xml door plaats_id.xsl ==> output ProjectBesluit_2_ids.xml
3. Transformatie file "ProjectBesluit_2_ids.xml door AKN.xsl ==> output ProjectBesluit_3_akn.xml
4. Verwijder namespaces bij  ProjectBesluit_3_akn.xml en copy file in input directory.
5. Uitvoeren buid.xml om html output te maken.



**Valdiation XML

xmlns="https://standaarden.overheid.nl/stop/imop/"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="https://standaarden.overheid.nl/stop/imop/ ./xsd_stop_0.97.1_imop_0.97.1.xsd"

20190917 - KL
Bestanden verplaatst naar IMOP en IMOW folders.
Folder Projectbesluit bevat nog de oude bestanden.
XML-schema's in algemene folders: repositories 'imop-algemeen' en 'imow-algemeen'