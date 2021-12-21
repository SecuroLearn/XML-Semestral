<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" indent="yes"/>

<!-- PDF pages setup -->
<xsl:template match="/">
    <fo:root>

        <fo:layout-master-set>

            <fo:simple-page-master master-name="A4-portrait" page-height="29.7cm" page-width="21.0cm" margin="1cm 2cm 1cm 2cm">
                <fo:region-body margin-top="2cm" margin-bottom="1.5cm"/>
                <fo:region-before extent="2cm" display-align="before"/>
                <fo:region-after extent="1.5cm" display-align="after"/>
            </fo:simple-page-master>

        </fo:layout-master-set>

        <fo:page-sequence master-reference="A4-portrait">

            <fo:static-content flow-name="xsl-region-before">
                <fo:block text-align="center" color="gray">
                    <fo:retrieve-marker retrieve-class-name="area"/> - <fo:retrieve-marker retrieve-class-name="section"/>
                </fo:block>
            </fo:static-content>

            <fo:static-content flow-name="xsl-region-after">
                <fo:block text-align="center" color="gray">
                    <fo:page-number/> / <fo:page-number-citation ref-id="terminator"/>
                </fo:block>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body" font-family="Times">
                <xsl:apply-templates select="areas"/>
            </fo:flow>

        </fo:page-sequence>

    </fo:root>
</xsl:template>

<!-- PDF content -->
<xsl:template match="areas">

    <fo:block font-weight="bold"  font-size="36pt" text-align="center" space-after="5px">
        <fo:marker marker-class-name="area">Facts about six countries</fo:marker>
        <xsl:text>Facts about six countries</xsl:text>
    </fo:block>
    <fo:block font-size="24pt"  font-style="italic" text-align="center" space-after="25px">
        <xsl:text>from the CIA's World Factbook</xsl:text>
    </fo:block>
    <fo:block space-after="20px">
        <fo:leader leader-length="100%" leader-pattern="rule" alignment-baseline="middle" rule-thickness="1px" color="gray"/>
    </fo:block>

    <fo:block font-size="26pt" space-after="10px">
        <fo:marker marker-class-name="section">Table of contents</fo:marker>
        <xsl:text>Table of contents</xsl:text>
    </fo:block>
    <fo:list-block provisional-distance-between-starts="40px" provisional-label-separation="5px">
        <xsl:apply-templates select="area" mode="link"/>
    </fo:list-block>

    <fo:block>
      <xsl:apply-templates select="area" mode="detail"/>
    </fo:block>

    <fo:block id="terminator"/>

</xsl:template>

<!-- Link to the page for a specific country -->
<xsl:template match="area" mode="link">
    <fo:list-item space-after="5px">
        <fo:list-item-label end-indent="label-end()">
            <fo:block>
                <fo:page-number-citation ref-id="{generate-id(.)}"/>
            </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
            <fo:block font-size="12px">
                <fo:basic-link internal-destination="{generate-id(.)}" color="blue" text-decoration="underline">
                    <xsl:value-of select="@name"/>
                </fo:basic-link>
            </fo:block>
        </fo:list-item-body>
    </fo:list-item>
</xsl:template>

<!-- Chapter starting on a new page for every country -->
<xsl:template match="area" mode="detail">

    <fo:block id="{generate-id(.)}" font-size="28pt" font-weight="bold" font-family="Helvetica"
              text-transform="uppercase" text-align="center" letter-spacing="2px" page-break-before="always">
        <fo:marker marker-class-name="area">
            <xsl:value-of select="@name"/>
        </fo:marker>
        <xsl:value-of select="@name"/>
    </fo:block>
    <fo:block space-after="15px">
        <fo:leader leader-length="100%" leader-pattern="rule" alignment-baseline="middle" rule-thickness="1px" color="gray"/>
    </fo:block>
    
	<fo:table table-layout="fixed" width="100%" space-before="10px">
        <fo:table-body>
            <fo:table-row>
                <xsl:apply-templates select="./section[@title='Images']/content[@type='image-link']"/>
            </fo:table-row>
        </fo:table-body>
    </fo:table>

    <fo:block space-before="15px">
        <fo:leader leader-length="100%" leader-pattern="rule" alignment-baseline="middle" rule-thickness="1px" color="gray"/>
    </fo:block>
    <fo:block font-size="24pt" space-before="10px" space-after="10px">
        Table of contents
    </fo:block>
    <fo:list-block provisional-distance-between-starts="40px" provisional-label-separation="5px">
        <xsl:apply-templates select="section" mode="link"/>
    </fo:list-block>

    <fo:block>
        <xsl:apply-templates select="section" mode="detail"/>
    </fo:block>
    
</xsl:template>

<!-- Table cell with an image and its description -->
<xsl:template match="content[@type='image-link']">
    <fo:table-cell>
        <fo:block font-size="12px" font-style="italic" text-align="center" space-after="5px">
			<xsl:value-of select="@description"/>
        </fo:block>
        <fo:block text-align="center">
            <fo:external-graphic src="url({@href})" content-height="90px"/>
        </fo:block>
    </fo:table-cell>
</xsl:template>

<!-- Link to a section -->
<xsl:template match="section[not(@title='Images')]" mode="link">
    <fo:list-item space-after="5px">
        <fo:list-item-label end-indent="label-end()">
            <fo:block>
                <fo:page-number-citation ref-id="{generate-id(.)}"/>
            </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
            <fo:block font-size="12px">
                <fo:basic-link internal-destination="{generate-id(.)}" color="blue" text-decoration="underline">
                    <xsl:value-of select="@title"/>
                </fo:basic-link>
            </fo:block>
        </fo:list-item-body>
    </fo:list-item>
</xsl:template>

<!-- Section title and contents -->
<xsl:template match="section[not(@title='Images')]" mode="detail">
    <fo:block id="{generate-id(.)}" space-before="15px">
        <fo:marker marker-class-name="section">
            <xsl:value-of select="@title"/>
        </fo:marker>
        <fo:leader leader-length="100%" leader-pattern="rule" alignment-baseline="middle" rule-thickness="1px" color="gray"/>
    </fo:block>
    <fo:block font-size="24pt" space-before="10px">
        <xsl:value-of select="@title"/>
    </fo:block>
    <xsl:apply-templates select="subsection"/>
</xsl:template>

<!-- Subsection title and contents -->
<xsl:template match="subsection">
    <fo:block font-size="15pt" font-weight="bold" space-before="12px">
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
    <fo:block font-style="italic" color="gray" space-before="5px">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>.)</xsl:text>
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