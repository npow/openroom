<!DOCTYPE stylesheet [
<!ENTITY space "<xsl:text> </xsl:text>">
<!ENTITY qt "<xsl:text>&quot;</xsl:text>">
<!ENTITY cr "<xsl:text>
</xsl:text>">
]>

<xsl:stylesheet version="2.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xhtml xsl">

  <xsl:output method="text"/>

  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="*/*/*/*/*/*/*/xhtml:td[matches(., '^\d\d:\d\d-\d\d:\d\d[MThWF]+$')]">
    <xsl:if test="not(not(normalize-space(following-sibling::*[1])))">
      <xsl:text>( </xsl:text>
      <xsl:analyze-string select="following-sibling::*[1]" regex="([A-Za-z0-9]+)\W+([A-Za-z0-9]+)">
        <xsl:matching-substring>
          &qt;<xsl:value-of select="regex-group(1)"/>&qt;&space;
          &qt;<xsl:value-of select="regex-group(2)"/>&qt;&space;
        </xsl:matching-substring>
      </xsl:analyze-string>

      <xsl:analyze-string select="." regex="(\d\d):(\d\d)-(\d\d):(\d\d)([MThWF]+)">
        <xsl:matching-substring>
          <xsl:variable name="start-time" select="concat(regex-group(1), regex-group(2))"/>
          <xsl:variable name="end-time" select="concat(regex-group(3), regex-group(4))"/>
          <xsl:choose>
            <xsl:when test="xs:integer($start-time) &lt;=829">
              <xsl:value-of select="xs:integer($start-time) + 1200"/>&space;
              <xsl:value-of select="xs:integer($end-time) + 1200"/>&space;
            </xsl:when>
            <xsl:when test="xs:integer($end-time) &lt;=829">
              <xsl:value-of select="$start-time"/>&space;
              <xsl:value-of select="xs:integer($end-time) + 1200"/>&space;
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$start-time"/>&space;
              <xsl:value-of select="$end-time"/>&space;
            </xsl:otherwise>
          </xsl:choose>
          &qt;<xsl:value-of select="replace(regex-group(5), 'Th', 'H')"/>&qt;&space;
        </xsl:matching-substring>
      </xsl:analyze-string>
      <xsl:text>)</xsl:text>&cr;
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
