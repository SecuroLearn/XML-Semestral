<xsl:stylesheet version = '2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
<xsl:output indent="yes" method="xml" />

<xsl:template match="/">
    <xsl:apply-templates select="/html/body/div/div/div/main"/>
</xsl:template>

<!-- Main content of the source HTML -->
<xsl:template match="main">
    <xsl:element name="area">
        <xsl:attribute name="name">
            <xsl:value-of select="//h1[@class='hero-title']"/>
        </xsl:attribute>
        <xsl:apply-templates select="//div[@class='free-form-content__content wysiwyg-wrapper']"/>
    </xsl:element>
</xsl:template>

<!-- Section -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']">
    <xsl:element name="section">
        <xsl:attribute name="title">
            <xsl:value-of select="h2"/>
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
            <xsl:apply-templates select="p"/>
    </xsl:element>
</xsl:template>

<!-- Content (paragraphs without children) -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/p[not(*)]">
    <xsl:element name="content">
        <xsl:value-of select="."/>
    </xsl:element>
</xsl:template>

<!-- Complicated content (paragraphs with children) -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/p[strong]">
    <xsl:element name="content">
        <xsl:value-of select="."/>
    </xsl:element>
</xsl:template>

<xsl:template match="*"/>

</xsl:stylesheet>