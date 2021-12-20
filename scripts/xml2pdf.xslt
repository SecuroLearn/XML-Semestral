<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
    <fo:root>
        <fo:layout-master-set>
            <fo:simple-page-master master-name="A4-portrait" page-height="29.7cm" page-width="21.0cm" margin="2cm">
                <fo:region-body/>
            </fo:simple-page-master>
        </fo:layout-master-set>
        <fo:page-sequence master-reference="A4-portrait">
          <fo:flow flow-name="xsl-region-body">
            <xsl:apply-templates select="areas"/>
          </fo:flow>
        </fo:page-sequence>
    </fo:root>
</xsl:template>

<xsl:template match="areas">
    <fo:block color = "red" font-size="32pt" space-after="20px">
        Areas
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="area" mode="link"/>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="area" mode="detail"/>
    </fo:block>
</xsl:template>

<xsl:template match="area" mode="link">
    <fo:block>
        <fo:basic-link internal-destination="{generate-id(.)}" color="blue" text-decoration="underline">
            <xsl:value-of select="@name"/>
        </fo:basic-link>
    </fo:block>
</xsl:template>

<xsl:template match="area" mode="detail">
    <fo:block id="{generate-id(.)}" font-size="32pt" space-after="20px" page-break-before="always">
        <xsl:value-of select="@name"/>
    </fo:block>
	<fo:table table-layout="fixed" width="100%">
        <fo:table-body>
            <fo:table-row>
                <xsl:apply-templates select="./section[@title='Images']/content[@type='image-link']"/>
            </fo:table-row>
        </fo:table-body>
    </fo:table>
</xsl:template>

<xsl:template match="content[@type='image-link']">
    <fo:table-cell>
        <fo:block>
			<xsl:value-of select="@description"/>
        </fo:block>
        <fo:block>
            <fo:external-graphic src="url({@href})" content-height="80px"/>
        </fo:block>
    </fo:table-cell>
</xsl:template>

</xsl:stylesheet>