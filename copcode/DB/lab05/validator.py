import xmlschema
#from lxml import etree
#from io import StringIO
import sys

xml_name = sys.argv[1]
#with open(xml_name, 'r') as f:
#    xml = StringIO(f.read())

xsd_name = sys.argv[2]
#with open(xsd_name, 'r') as f:
#    xsd = etree.parse(f.read())

schema = xmlschema.XMLSchema(xsd_name) #etree.XMLSchema(xsd)
#doc = etree.parse(xml)
schema.validate(xml_name)
print('Valid')


#if schema.is_valid(xml_name): #validate(doc):
#    print('Valid')
#else:
#    print('Invalid')
