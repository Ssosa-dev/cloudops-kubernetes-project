import uvicorn
from fastapi import FastAPI

app = FastAPI(title = "My CloudOps Application")

@app.get("/")
def read_root():
    return {
        "status": "healthy",
        "message": "Hello World",
        "version": "1.0.0"
    }

if __name__ == "__main__":
    uvicorn.run("app:app", host = "0.0.0.0" , port = 8000, reload = True)