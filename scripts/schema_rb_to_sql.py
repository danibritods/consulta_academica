import regex as re
FILEPATH = 'schema.rb'

def read_file(file_path):
    with open(file_path, 'r') as f:
        read_file = f.read()
    return read_file

def save_file(file_path, content):
    with open(file_path, 'w') as f:
        f.write(content)

def parser(schema_rb):
    tables = get_tables(schema_rb)
    sql = "\n".join([table_parser(table) for table in tables])
    return sql

def get_tables(schema_rb):
    tables = re.findall(r'create_table \"(.*?)\".*?\|t\|(.*?)end', schema_rb, re.DOTALL)
    return tables

def table_parser(table):
    table_name = table[0]
    columns = columns_parser(table[1])
    
    sql_table = f"CREATE TABLE {table_name}(\n{columns}\n);\n"
    return sql_table

def columns_parser(columns):
    substitution_dict = {
    r'(.*) "(.*)"': r'\2 \1',
    r',': " ",

    r" *t\.integer": " integer",
    r" *t\.bigint": " bigint",
    r" *t\.string": " text",
    r" *t\.datetime": " date",
    r" *t\.decimal.*precision: ([\d*]).*scale: ([\d*])": r" numeric(\1,\2)",

    r'null: false': "NOT NULL",
    r"t.index.*\n": "", #fix later
    r"default: \d*":"", #fix_later
    r"#.*\n" : "\n",

    r'^' : r'    '
    # r'$\n' :r',\n'

    }

    # parsed_columns = re.sub("|".join(dictionary.keys()), lambda m: dictionary[m.group()], columns)

    parsed_columns = columns.strip()
    for pattern, replacement in substitution_dict.items():
        parsed_columns = re.sub(pattern,replacement,parsed_columns, flags=re.MULTILINE)

    return parsed_columns


if __name__ == "__main__":
    sql = parser(read_file(FILEPATH))
    save_file("academico.sql",sql)
    print(sql)
    