<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:gml="http://www.opengis.net/gml/3.2" exclude-result-prefixes="#all">
    
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>   
    <xsl:param name="alginelement" select="('tgroup','entry')"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <!-- Delete extra Metadata???? -->
    <xsl:template match="Besluit/Metadata/Uitspraak/Object/Eigenschap/Geometrie/Metadata" priority="1">
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <!-- add attribute align to tgroup and entry -->
    
    <xsl:template match="tgroup" priority="1">      
        <xsl:copy>
            <xsl:attribute name="align">left</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="entry" priority="1">      
        <xsl:copy>
            <xsl:attribute name="align">left</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- begin Replace value of Waarde imop:Geometrie --> 
    <xsl:variable name="werkingsgebiedID" select="fn:generate-id()" />
    <xsl:variable name="Dateid" select="translate(substring(string(current-dateTime()), 1, 23), '-:T.', '')"/>
    <xsl:variable name="wekingsId" select= "concat($werkingsgebiedID,'/regdata/gm0503/',$Dateid)"/>
   
    <xsl:template match="@type">
        <xsl:choose>
            <xsl:when test=". eq 'imop:Geometrie'"> 
                <xsl:attribute name="{name()}" select="string('imop:Geometrie')"/>
                <xsl:value-of select="concat($werkingsgebiedID,'/regdata/gm0503/',$Dateid)"/>     
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>  
    <!-- 
    <xsl:template match="@eigenschap">      
        <xsl:choose>
            <xsl:when test=". eq 'imop:werkingsgebied'">              
                <xsl:element name="Waarde">
                    <xsl:attribute name="type" select="string('imop:Geometrie')"/>
                    <xsl:value-of select="concat($werkingsgebiedID,'/regdata/gm0503/',$Dateid)"/>    
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise> 
        </xsl:choose>
    </xsl:template>
     -->
    <xsl:template match="@doel">
        <xsl:choose>
            <xsl:when test=". eq ''">
                <xsl:attribute name="doel" select="concat($werkingsgebiedID,'/regdata/gm0503/',$Dateid)"></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- end Replace value of Waarde imop:Geometrie -->
    
</xsl:stylesheet>