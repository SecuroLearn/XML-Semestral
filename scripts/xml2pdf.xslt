<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" indent="yes"/>

<!-- PDF metadata -->
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

<!-- PDF content -->
<xsl:template match="areas">
    <fo:block color = "red" font-size="32pt" space-after="15px">
        Areas
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="area" mode="link"/>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="area" mode="detail"/>
    </fo:block>
</xsl:template>

<!-- Link to the page for a specific country -->
<xsl:template match="area" mode="link">
    <fo:block>
        <fo:basic-link internal-destination="{generate-id(.)}" color="blue" text-decoration="underline">
            <xsl:value-of select="@name"/>
        </fo:basic-link>
    </fo:block>
</xsl:template>

<!-- Chapter starting on a new page for every country -->
<xsl:template match="area" mode="detail">

    <fo:block id="{generate-id(.)}" font-size="26pt" space-after="20px" page-break-before="always">
        <xsl:value-of select="@name"/>
    </fo:block>
    
	<fo:table table-layout="fixed" width="100%" space-before="10px">
        <fo:table-body>
            <fo:table-row>
                <xsl:apply-templates select="./section[@title='Images']/content[@type='image-link']"/>
            </fo:table-row>
        </fo:table-body>
    </fo:table>

    <fo:block>
        <xsl:apply-templates select="section"/>
    </fo:block>
    
</xsl:template>

<!-- Table cell with an image and its description -->
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

<!-- Section title and contents -->
<xsl:template match="section[not(@title='Images')]">
    <fo:block font-size="22pt" space-before="15px">
        <xsl:value-of select="@title"/>
    </fo:block>
    <xsl:apply-templates select="subsection"/>
</xsl:template>

<!-- Subsection title and contents -->
<xsl:template match="subsection">
    <fo:block font-size="15pt" space-before="12px">
        <xsl:value-of select="@title"/>
    </fo:block>
    <fo:block>
        <xsl:apply-templates select="./content"/>
    </fo:block>
</xsl:template>

<!-- Basic content in a paragraph -->
<xsl:template match="content[not(@type)]">
    <fo:block space-before="2px">
        <xsl:value-of select="."/>
    </fo:block>
</xsl:template>

<!-- Strong content -->
<xsl:template match="content[@type='strong']">
    <fo:block font-size="12pt" space-before="8px">
        <xsl:value-of select="concat(translate(substring(.,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring(., 2))"/>
    </fo:block>
</xsl:template>

<!-- Comparison content -->
<xsl:template match="content[@type='comparison-link']">
    <fo:block font-style="italic" space-before="2px">
            <xsl:value-of select="."/>
    </fo:block>
</xsl:template>

<!-- External link content -->
<xsl:template match="content[@type='external-link']">
    <fo:block space-before="5px">
        <fo:basic-link external-destination="url({@href})" color="blue" text-decoration="underline">
            <xsl:value-of select="."/>
        </fo:basic-link>
    </fo:block>
</xsl:template>

<!-- Not supported elements in PDF ( such as audio ;( ) -->
<xsl:template match="*"/>

</xsl:stylesheet>