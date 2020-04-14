<?xml version="1.0"?>
<!--
  Author: Johannes Willkomm <jwillkomm@ai-and-it.de>
-->
<xsl:stylesheet version="1.0"
                xmlns:x="http://ai-and-it.de/xml/xnl/"
                xmlns:ca="http://ai-and-it.de/xml/xnl/attributes/"
                xmlns:cc="http://ai-and-it.de/xml/xnl/comments/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

  <xsl:template match="text()"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="x:*">
    <xsl:value-of select="local-name()"/> &lt;- list(
    <xsl:for-each select="x:*">
      <xsl:if test="position() > 1">, </xsl:if>
      `<xsl:value-of select="local-name()"/>` = <xsl:apply-templates select="." mode="in-list"/>
    </xsl:for-each>)
  </xsl:template>

  <xsl:template match="x:*" mode="in-list">
    list(
    <xsl:for-each select="@*">
      <xsl:if test="position() > 1">, </xsl:if>
      `<xsl:value-of select="local-name()"/>` = '<xsl:value-of select="."/>'
    </xsl:for-each>
    <xsl:if test="count(@*) > 0">, </xsl:if>
    <xsl:for-each select="x:*">
      <xsl:if test="position() > 1">, </xsl:if>
      `<xsl:value-of select="local-name()"/>` = <xsl:apply-templates select="." mode="in-list"/>
    </xsl:for-each>
    )
  </xsl:template>

  <xsl:template match="x:*[count(x:*)=0]"
                mode="in-list">'<xsl:value-of select="."/>'</xsl:template>

</xsl:stylesheet>
