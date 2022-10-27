# DropDownContainer

- [source](https://www.w3schools.com/tags/tag_select.asp)

```
import PropTypes from "prop-types";
import styled from "styled-components";

const DropDownBlockDiv = styled.div`
  position: relative;
`;

const DropDownDiv = styled.div`
  display: none;
  position: absolute;
  &:hover {
    display: block;
  }
`;

const TriggerDiv = styled.div`
  &:hover ~ ${DropDownDiv} {
    display: block;
  }
`;

const DropDownContainer = ({ text, children }) => {
  return (
    <DropDownBlockDiv>
      <TriggerDiv>{text}</TriggerDiv>
      <DropDownDiv>{children}</DropDownDiv>
    </DropDownBlockDiv>
  );
};

DropDownContainer.propTypes = {
  words: PropTypes.arrayOf(PropTypes.string.isRequired),
};

// use above code like this
const DropDownItem = ({})=>{
  return <DropDownContainer>Add child elements here.</DropDownContainer>;
}

```