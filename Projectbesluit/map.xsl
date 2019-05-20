<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:imop="http://www.overheid.nl/imop/def# ./xsd_stop_0.97.1.xsd"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:gml="http://www.opengis.net/gml/3.2" exclude-result-prefixes="#all">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  
    <!-- make varible for mapping new elements of 97.1 -->
    <xsl:variable name="map">
        <element old="al" new="Al"/>
        <element old="b" new="b"/>
        <element old="entry" new="entry"/>
        <element old="Geometrie" new="Geometrie"/>
        <element old="Inhoud" new="Inhoud"/>
        <element old="Kop" new="Kop"/>
        <element old="Li" new="Li"/>
        <element old="Lijst" new="Lijst"/>
        <element old="Lijstaanhef" new="Lijstaanhef"/>
        <element old="Locatiegroep" new="Onbekend"/>
        <element old="Locaties" new="Onbekend"/>
        <element old="Metadata" new="Metadata"/>
        <element old="OfficielePublicatie" new="Onbekend"/>
        <element old="Opschrift" new="Opschrift"/>
        <element old="row" new="row"/>
        <element old="Staatsblad" new="Onbekend"/>
        <element old="table" new="table"/>
        <element old="tbody" new="tbody"/>
        <element old="Tekst" new="Onbekend"/>
        <element old="tgroup" new="tgroup"/>
        <element old="thead" new="thead"/>
        <element old="title" new="title"/>
        <element old="Tussenkop" new="Tussenkop"/>
        <element old="Uitspraak" new="Uitspraak"/>
        <element old="Waarde" new="Waarde"/>
    </xsl:variable>
    
    <!-- Replace old elemnet with new one from variable $map -->    
    <xsl:template match="element()" priority="0">
        <xsl:variable name="name" select="name()" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$map/element[@old=$name]">
                <xsl:element name="{$map/element[@old=$name]/@new}">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$name}">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Delete elemnet Locatie -->
    <xsl:template match="OfficielePublicatie/Locaties" priority="1">
    </xsl:template>
     
    <!-- Replace imop:objectRef to imop:Geometrie --> 
    <xsl:template match="@*">
        <xsl:choose>
            <xsl:when test=". eq 'imop:objectRef'">
                <xsl:attribute name="type" select="string('imop:Geometrie')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
   
    <!-- Add namesapce for validation -->
    <xsl:template match="OfficielePublicatie" priority="1">
        <xsl:element name="Besluit">
            <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.overheid.nl/imop/def# ./xsd_stop_0.97.1_imop_0.97.1.xsd')"/>
            <xsl:namespace name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
            <xsl:namespace name="imop" select="string('https://standaarden.overheid.nl/stop/imop/')"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   
    <!-- Copy Gemotrie from Locaties to metadata --> 
    <xsl:template match="OfficielePublicatie/Metadata" priority="1">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:element name="Uitspraak">
                <xsl:attribute name="eigenschap" select="string('imop:heeftDatacollectie')"> 
                </xsl:attribute> 
                <xsl:element name="Object">
                    <xsl:attribute name="type" select="string('imop:GeoInformatieobject')"/>  
                    <xsl:element name="Eigenschap">
                        <xsl:attribute name="naam" select="string('imop:Geometrie')"/> 
                        <xsl:element name="Geometrie">
                            <xsl:copy>
                                <xsl:apply-templates select="ancestor::OfficielePublicatie/Locaties/Geometrie/*"/>
                            </xsl:copy>
                        </xsl:element>    
                    </xsl:element>              
                </xsl:element>
            </xsl:element>
        </xsl:copy>
    </xsl:template>   
    
    <!-- Replace element Staatsblad tree -->
    <xsl:template match="Staatsblad" priority="1">
        <xsl:element name="Regeling">
            <xsl:element name="Lichaam">
                <xsl:element name="WijzigArtikel">
                    <xsl:element name="Metadata">
                        <xsl:element name="Uitspraak">
                            <xsl:attribute name="eigenschap" select="string('imop:datumInwerkingtreding')"/>
                            <xsl:element name="Waarde">
                                <xsl:attribute name="type" select="string('xs:date')"/>
                                <xsl:value-of select="ancestor::OfficielePublicatie/Metadata/Uitspraak[@eigenschap='imop:datumInwerkingtreding']/Waarde"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="Uitspraak">
                            <xsl:attribute name="eigenschap" select="string('imop:wijzigBijlage')"/>
                            <xsl:element name="Waarde">
                                <xsl:attribute name="type" select="string('xs:string')"/>
                                <xsl:value-of select="string('#cmp_1')"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Kop">
                        <xsl:element name="Label">
                            <xsl:text>Artikel</xsl:text>
                        </xsl:element>
                        <xsl:element name="Nummer">
                            <xsl:text>I</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Wat">
                        <xsl:value-of select="concat(ancestor::OfficielePublicatie/Metadata/Uitspraak[@eigenschap='imop:citeertitel']/Waarde,' wordt vastgesteld zoals vastgesteld in de bijlage.')"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Artikel">
                    <xsl:element name="Kop">
                        <xsl:element name="Label">
                            <xsl:text>Artikel</xsl:text>
                        </xsl:element>
                        <xsl:element name="Nummer">
                            <xsl:text>II</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Inhoud">
                        <xsl:element name="Al">
                            <xsl:value-of select="concat('Dit besluit treedt in werking per ',ancestor::OfficielePublicatie/Metadata/Uitspraak[@eigenschap='imop:datumInwerkingtreding']/Waarde,'.')"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="WijzigBijlage">
                <!-- Waarde van imop:wordtVersie door AKN.xsl laten toevoegen -->
                <xsl:element name="Metadata">
                    <xsl:element name="Uitspraak">
                        <xsl:attribute name="eigenschap" select="string('imop:wordtVersie')"/>
                        <xsl:element name="Waarde">
                            <xsl:attribute name="type" select="string('xs:string')"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Kop">
                    <xsl:element name="Label">
                        <xsl:text>Bijlage</xsl:text>
                    </xsl:element>
                    <xsl:element name="Nummer">
                        <xsl:text>I</xsl:text>
                    </xsl:element>
                    <xsl:element name="Opschrift">
                        <xsl:text>Bijlage bij artikel I</xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="MaakInitieleRegeling">
                    <xsl:element name="Lichaam">
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="Bijlage">
                <xsl:element name="Kop">
                    <xsl:element name="Label">Bijlage</xsl:element>
                    <xsl:element name="Nummer">I</xsl:element>
                    <xsl:element name="Opschrift">Overzicht informatieobjecten</xsl:element>
                 </xsl:element>
                <xsl:element name="Inhoud">
                    <xsl:element name="Begrippenlijst">
                        <xsl:element name="Begrip">
                            <xsl:element name="Term"> 
                                Werkinggebied A
                            </xsl:element>
                            <xsl:element name="Definitie">
                                <xsl:element name="Al">
                                    <xsl:element name="ExIoRef">
                                        <xsl:attribute name="wId"></xsl:attribute>
                                        <xsl:attribute name="eId"></xsl:attribute>
                                        <xsl:attribute name="doel"></xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- Replace element Tekst|Divisiie to FoemeleDivisie -->
    <xsl:template match="Tekst|Divisie" priority="1">
        <xsl:element name="FormeleDivisie">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Replace element Divisiie|Inhoud to FoemeleInhoud -->
    <xsl:template match="Divisie/Inhoud" priority="1">
        <xsl:element name="FormeleInhoud">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Delete element tree Locatiegroep -->
    <xsl:template match="OfficielePublicatie/Locaties/Locatiegroep" priority="1">
    </xsl:template>
    
</xsl:stylesheet>