<xsl:stylesheet version = '2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
<xsl:output indent="yes" method="xml" />

<xsl:template match="/">
    <xsl:apply-templates select="/html/body/div/div/div/main"/>
</xsl:template>

<!-- Main content of the source HTML -->
<xsl:template match="main">
    <xsl:element name="area">
        <xsl:attribute name="name">
            <xsl:value-of select="normalize-space(//h1[@class='hero-title'])"/>
        </xsl:attribute>
        <xsl:apply-templates select="//div[@class='free-form-content__content wysiwyg-wrapper']"/>
    </xsl:element>
</xsl:template>

<!-- Section -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']">
    <xsl:element name="section">
        <xsl:attribute name="title">
            <xsl:value-of select="normalize-space(h2)"/>
        </xsl:attribute>
        <xsl:apply-templates select="div"/>
    </xsl:element>
</xsl:template>

<!-- Subsection -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div">
    <xsl:element name="subsection">
        <xsl:attribute name="title">
            <xsl:value-of select="normalize-space(h3/a)"/>
        </xsl:attribute>
            <xsl:apply-templates select="p | a"/>
    </xsl:element>
</xsl:template>

<!-- Content paragraphs -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/p">
    <xsl:apply-templates select="strong | text() | p"/>
</xsl:template>

<!-- Basic text content -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/p/text()">
    <xsl:if test="string-length(normalize-space(.))!=0">
        <xsl:element name="content">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:if>
</xsl:template>

<!-- Strong text content -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/p/strong">
    <xsl:element name="content">
        <xsl:attribute name="type">strong</xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
</xsl:template>

<!-- Nested paragraph -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/p/p">
    <xsl:if test="string-length(.)!=0">
        <xsl:element name="content">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:if>
</xsl:template>

<!-- Comparison url link content -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/a">
    <xsl:element name="content">
        <xsl:attribute name="type">external-link</xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
</xsl:template>

<xsl:template match="*"/>

</xsl:stylesheet>