def write_file(content,path) -> bool :
    cert=open(path,"wt")
    success=True

    try:
        cert.write(content)
        cert.close()
    except ex:
        success=False
        raise Exception(ex)
    finally:
        cert.close()
    return success
