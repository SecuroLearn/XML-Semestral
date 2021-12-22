<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
<xsl:output indent="yes" method="html" />

<xsl:template match="/">
    <xsl:apply-templates select="areas"/>
</xsl:template>

<!-- HTML file generation of index.html -->
<xsl:template match="areas">
    <xsl:result-document href="output/html/index.html">
        <xsl:element name="html">
            <xsl:element name="head">
                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="href">./style-index.css</xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:element name="body">
                <xsl:element name="h1">Facts about six countries</xsl:element>
                <xsl:element name="h2">from the CIA's World Factbook</xsl:element>
                <xsl:element name="ul">
                    <xsl:apply-templates select="area" mode="link"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:result-document>

    <xsl:apply-templates select="area" mode="detail"/>
</xsl:template>

<!-- Link to the HTML page for a specific country -->
<xsl:template match="area" mode="link">
    <xsl:element name="li">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="concat(translate(@name, ' ()', ''), '.html' )"/>
            </xsl:attribute>
            <xsl:value-of select="@name"/>
            <xsl:text>&#8239;&#8239;&#8239;&#10095;</xsl:text>
        </xsl:element>
    </xsl:element>
</xsl:template>

<!-- HTML file generation for every single country -->
<xsl:template match="area" mode="detail">
    <xsl:result-document href="{concat('output/html/', translate(@name, ' ()', ''), '.html' )}">
        <xsl:element name="html">
            <xsl:element name="head">
                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="href">./style-area.css</xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:element name="body">
                <xsl:element name="h1">
                    <xsl:value-of select="@name"/>
                </xsl:element>
                <xsl:element name="a">
                    <xsl:attribute name="class">back-button</xsl:attribute>
                    <xsl:attribute name="href">index.html</xsl:attribute>
                    <xsl:text>&#10094;&#8239;&#8239;&#8239;Back to main page</xsl:text>
                </xsl:element>
                <xsl:element name="div">
                    <xsl:element name="table">
                        <xsl:attribute name="class">images</xsl:attribute>
                        <xsl:element name="tr">
                            <xsl:apply-templates select="./section[@title='Images']/content[@type='image-link']"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="hr"/>
                <xsl:element name="h2">
                    Table of contents
                </xsl:element>
                <xsl:element name="ul">
                    <xsl:apply-templates select="section" mode="link"/>
                </xsl:element>
                <xsl:apply-templates select="./section[not(@title='Images')]" mode="detail"/>
            </xsl:element>
        </xsl:element>
    </xsl:result-document>
</xsl:template>

<!-- Image with description -->
<xsl:template match="content[@type='image-link']">
    <xsl:element name="td">
        <xsl:element name="p">
            <xsl:element name="i">
                <xsl:value-of select="@description"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="img">
            <xsl:attribute name="src">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:element>
</xsl:template>

<!-- Link to section -->
<xsl:template match="section[not(@title='Images')]" mode="link">
    <xsl:element name="li">
        <xsl:element name="a">
            <xsl:attribute name="class">button-section</xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="generate-id(.)"/>
            </xsl:attribute>
            <xsl:value-of select="translate(@title, ' ', '&#160;')"/>
            <xsl:text>&#8239;&#8239;&#8239;&#10095;</xsl:text>
        </xsl:element>
    </xsl:element>
</xsl:template>

<!-- Section title and contents -->
<xsl:template match="section[not(@title='Images')]" mode="detail">
    <xsl:element name="hr">
        <xsl:attribute name="id">
            <xsl:value-of select="generate-id(.)"/>
        </xsl:attribute>
    </xsl:element>
    <xsl:element name="h2">
        <xsl:value-of select="@title"/>
    </xsl:element>
    <xsl:apply-templates select="subsection"/>
</xsl:template>

<!-- Subsection title and contents -->
<xsl:template match="subsection">
    <xsl:element name="h3">
        <xsl:value-of select="@title"/>
    </xsl:element>
    <xsl:element name="div">
        <xsl:apply-templates select="./content"/>
    </xsl:element>
</xsl:template>

<!-- Basic content in a paragraph -->
<xsl:template match="content[not(@type)]">
    <xsl:element name="p">
        <xsl:value-of select="."/>
    </xsl:element>
</xsl:template>

<!-- Strong content -->
<xsl:template match="content[@type='strong']">
    <xsl:element name="h4">
        <xsl:value-of select="concat(upper-case(substring(.,1,1)), substring(., 2))"/>
    </xsl:element>
</xsl:template>

<!-- Comparison content -->
<xsl:template match="content[@type='comparison-link']">
    <xsl:element name="p">
        <xsl:attribute name="class">comparison</xsl:attribute>
        <xsl:element name="i">
            <xsl:value-of select="."/><xsl:text>.</xsl:text>
        </xsl:element>
    </xsl:element>
</xsl:template>

<!-- External link content -->
<xsl:template match="content[@type='external-link']">
    <xsl:element name="p">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:element>
</xsl:template>

<!-- Audio content -->
<xsl:template match="content[@type='audio-link']">
    <xsl:element name="audio">
        <xsl:attribute name="controls"/>
        <xsl:element name="source">
            <xsl:attribute name="src">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:attribute name="type">audio/mpeg</xsl:attribute>
        </xsl:element>
    </xsl:element>
</xsl:template>

<xsl:template match="*"/>

</xsl:stylesheet>