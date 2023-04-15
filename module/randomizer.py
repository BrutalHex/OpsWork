import exrex



def getRandomLetters(length=5):
    return exrex.getone(f'[a-z]{length}')