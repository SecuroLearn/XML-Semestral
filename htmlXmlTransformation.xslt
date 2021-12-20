<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
<xsl:output indent="yes" method="xml" />

<xsl:variable name="source-url">https://www.cia.gov</xsl:variable>

<xsl:template match="/">
    <xsl:apply-templates select="/html/body/div/div/div/main"/>
</xsl:template>

<!-- Main content of the source HTML -->
<xsl:template match="main">
    <xsl:element name="area">
        <xsl:attribute name="name">
            <xsl:value-of select="normalize-space(//h1[@class='hero-title'])"/>
        </xsl:attribute>
        <xsl:element name="section">
            <xsl:attribute name="title">Images</xsl:attribute>
                <xsl:apply-templates select="//div[@class='row no-gutters']"/>
        </xsl:element>
        <xsl:apply-templates select="//div[@class='free-form-content__content wysiwyg-wrapper']"/>
    </xsl:element>
</xsl:template>

<!-- Image -->
<xsl:template match="div[@class='row no-gutters']">
    <xsl:if test="string-length(normalize-space(./div/div/div/img/@src))!=0">
        <xsl:element name="content">
            <xsl:attribute name="type">image-link</xsl:attribute>
            <xsl:attribute name="description">
                <xsl:value-of select="./div[2]/div/span"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of select="concat($source-url, ./div/div/div/img[last()]/@src)"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:if>
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
            <xsl:apply-templates select="p | a | span/div/audio"/>
    </xsl:element>
</xsl:template>

<!-- Content paragraphs -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/p">
    <xsl:apply-templates select="strong | text() | p | a"/>
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

<!-- External url link content -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/p/a">
    <xsl:element name="content">
        <xsl:attribute name="type">external-link</xsl:attribute>
        <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
</xsl:template>

<!-- Comparison url link content -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/a">
    <xsl:element name="content">
        <xsl:attribute name="type">comparison-link</xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
</xsl:template>

<!-- Audio content -->
<xsl:template match="div[@class='free-form-content__content wysiwyg-wrapper']/div/span/div/audio">
    <xsl:element name="content">
        <xsl:attribute name="type">audio-link</xsl:attribute>
        <xsl:attribute name="href">
            <xsl:value-of select="concat($source-url, @src)"/>
        </xsl:attribute>
    </xsl:element>
</xsl:template>

<xsl:template match="*"/>

</xsl:stylesheet>