<?xml version="1.0"?>
<!--
  Author: Johannes Willkomm <jwillkomm@ai-and-it.de>
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

  <xsl:template match="text()"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:value-of select="name()"/> &lt;- <xsl:apply-templates select="." mode="in-list"/>
  </xsl:template>

  <xsl:template match="*" mode="in-list">list(<xsl:for-each select="*">
      <xsl:if test="position() > 1">, </xsl:if>
      `<xsl:value-of select="name()"/>` = <xsl:apply-templates select="." mode="in-list"/></xsl:for-each>
    )</xsl:template>

  <xsl:template match="*[count(@*)>0]" mode="in-list">element(<xsl:for-each select="@*">
    <xsl:if test="position() > 1">, </xsl:if>`<xsl:value-of select="name()"/>` = '<xsl:value-of
      select="normalize-space(.)"/>'</xsl:for-each>,
            list(<xsl:for-each select="*">
       <xsl:if test="position() > 1">, </xsl:if>
       `<xsl:value-of select="name()"/>` = <xsl:apply-templates select="." mode="in-list"/></xsl:for-each>))</xsl:template>

  <xsl:template match="*[count(*)=0]"
                mode="in-list">'<xsl:value-of select="normalize-space(.)"/>'</xsl:template>

  <xsl:template match="*[count(*)=0 and count(@*)>0]" mode="in-list">element(<xsl:for-each select="@*">
              <xsl:if test="position() > 1">, </xsl:if>`<xsl:value-of
              select="name()"/>` = '<xsl:value-of select="normalize-space(.)"/>'</xsl:for-each>
              <xsl:variable name="str-val" select="normalize-space(.)"/>
              <xsl:if test="string-length($str-val)">,
            '<xsl:value-of select="normalize-space(.)"/>'</xsl:if>)</xsl:template>

</xsl:stylesheet>
