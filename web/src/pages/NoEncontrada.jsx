import { Link } from 'react-router';

function NoEncontrada() {
  return (
    <div className="container py-5 text-center">
      <h1 className="display-4">Página no encontrada</h1>
      <p className="fs-5 my-4">
        La dirección que escribiste no existe en APAR-CAR.
      </p>
      <Link to="/panel" className="btn btn-primary btn-lg">
        Volver al panel de control
      </Link>
    </div>
  );
}

export default NoEncontrada;