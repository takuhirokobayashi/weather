import styled from '@emotion/styled'

export const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
`

export const FormContainer = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;

  @media (max-width: 768px) {
    flex-direction: column;
    align-items: flex-start;
  }
`

export const Input = styled.input`
  padding: 10px;
  font-size: 16px;
`

export const Select = styled.select`
  padding: 10px;
  font-size: 16px;
`

export const Button = styled.button`
  padding: 10px;
  font-size: 16px;
  cursor: pointer;
`

export const TableContainer = styled.div`
  overflow-x: auto;
  max-width: 100%;
`

export const Table = styled.table`
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
`

export const TableHeader = styled.th`
  background-color: #f2f2f2;
  padding: 10px;
  border: 1px solid #ddd;
  text-align: center;
`

export const TableCell = styled.td`
  padding: 10px;
  border: 1px solid #ddd;
  text-align: ${ ( { align } ) => ( 'right' === align ? 'right' : ( 'left' === align ? 'left' : 'center' ) ) };
  position: relative;
`

export const TableRow = styled.tr`
  &:nth-of-type(even) {
    background-color: #f9f9f9;
  }
`

export const LoadingBar = styled.div`
  width: 100%;
  height: 8px;
  background: linear-gradient( 90deg, transparent, blue, transparent );
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  position: absolute;
  top: 50%;
  left: 0;
  transform: translateY( -50% );

  @keyframes loading {
    0% {
      background-position: 200% 0;
    }
    100% {
      background-position: -200% 0;
    }
  }
`
